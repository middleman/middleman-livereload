require 'rack/livereload'
require 'em-websocket'
require 'multi_json'

module Middleman
  module LiveReload
    class << self
      def registered(app, options={})
        options = {
          :api_version => '1.6',
          :host => '0.0.0.0',
          :port => '35729',
          :apply_js_live => true,
          :apply_css_live => true,
          :grace_period => 0
        }.merge(options)

        app.ready do
          # Doesn't make sense in build
          if environment != :build
            reactor = Reactor.new(options, self)

            files.changed do |file|
              sitemap.ensure_resource_list_updated!
              
              begin
                file_url = sitemap.file_to_path(file)
                file_resource = sitemap.find_resource_by_path(file_url)
                reload_path = file_resource.destination_path
              rescue
                reload_path = "#{Dir.pwd}/#{file}"
              end
              
              reactor.reload_browser(reload_path)
            end
            
            files.deleted do |file|
              sitemap.ensure_resource_list_updated!
              reactor.reload_browser("#{Dir.pwd}/#{file}")
            end

            use ::Rack::LiveReload, :port => options[:port].to_i, :host => options[:host]
          end
        end
      end
      alias :included :registered
    end

    class Reactor
      attr_reader :thread, :web_sockets, :app
      delegate :logger, :to => :app
      
      def initialize(options, app)
        @app = app
        @web_sockets = []
        @options     = options
        @thread      = start_threaded_reactor(options)
      end

      def stop
        thread.kill
      end

      def reload_browser(paths = [])
        paths = Array(paths)
        logger.info "== LiveReloading path: #{paths.join(' ')}"
        paths.each do |path|
          data = MultiJson.encode(['refresh', {
            :path           => path,
            :apply_js_live  => @options[:apply_js_live],
            :apply_css_live => @options[:apply_css_live]
          }])
          
          @web_sockets.each { |ws| ws.send(data) }
        end
      end

      def start_threaded_reactor(options)
        Thread.new do
          EventMachine.run do
            logger.info "== LiveReload is waiting for a browser to connect"
            EventMachine.start_server(options[:host], options[:port], EventMachine::WebSocket::Connection, {}) do |ws|
              ws.onopen do
                begin
                  ws.send "!!ver:#{options[:api_version]}"
                  @web_sockets << ws
                  logger.debug "== LiveReload browser connected"
                rescue
                  $stderr.puts $!
                  $stderr.puts $!.backtrace
                end
              end

              ws.onmessage do |msg|
                logger.debug "LiveReload Browser URL: #{msg}"
              end

              ws.onclose do
                @web_sockets.delete ws
                logger.debug "== LiveReload browser disconnected"
              end
            end
          end
        end
      end
    end
  end
end
