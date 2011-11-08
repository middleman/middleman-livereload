require 'em-websocket'
require 'multi_json'

module Middleman
  module Features
    module Livereload
      class << self
        def registered(app)
          app.set :livereload, {
            :api_version => '1.6',
            :host => '0.0.0.0',
            :port => '35729',
            :apply_js_live => true,
            :apply_css_live => true,
            :grace_period => 0
          }
          
          app.after_configuration do
            @options = app.livereload
            
            # Start reactor
            reactor
            
            app.on_file_change do |file|
              if app.sitemap.generic_paths.include?(file) || app.sitemap.all_values.include?(file)
                reactor.reload_browser(file)
              end
            end

            # app.on_file_delete do |file|
            #   reactor.reload_browser(file)
            # end
          end
        end
        alias :included :registered
        
        def reactor
          @reactor ||= Reactor.new(@options)
        end
      end

      class Reactor
        attr_reader :thread, :web_sockets

        def initialize(options)
          @web_sockets = []
          @options     = options
          @thread      = start_threaded_reactor(options)
        end

        def stop
          thread.kill
        end

        def reload_browser(paths = [])
          UI.info "Reloading browser: #{paths.join(' ')}"
          paths.each do |path|
            data = MultiJson.encode(['refresh', {
              :path           => "#{Dir.pwd}/#{path}",
              :apply_js_live  => @options[:apply_js_live],
              :apply_css_live => @options[:apply_css_live]
            }])
            UI.debug data
            @web_sockets.each { |ws| ws.send(data) }
          end
        end

      private

        def start_threaded_reactor(options)
          Thread.new do
            EventMachine.run do
              UI.info "LiveReload #{options[:api_version]} is waiting for a browser to connect."
              EventMachine.start_server(options[:host], options[:port], EventMachine::WebSocket::Connection, {}) do |ws|
                ws.onopen do
                  begin
                    UI.info "Browser connected."
                    ws.send "!!ver:#{options[:api_version]}"
                    @web_sockets << ws
                  rescue
                    UI.errror $!
                    UI.errror $!.backtrace
                  end
                end

                ws.onmessage do |msg|
                  UI.info "Browser URL: #{msg}"
                end

                ws.onclose do
                  @web_sockets.delete ws
                  UI.info "Browser disconnected."
                end
              end
            end
          end
        end
    end
  end
end

Middleman::Guard.add_guard do |options, livereload|
  if livereload
    livereload_options_hash = ""
    
    livereload.each do |k,v|
      livereload_options_hash << ", :#{k} => "
      livereload_options_hash << ((v.kind_of?(String)) ? "'#{v}'" : "#{v.to_s}")
    end
    
    %Q{
      guard 'livereload'#{livereload_options_hash} do 
        watch(%r{^source/([^\.].*)$})
        watch(%r{^data/([^\.].*)$})
      end
    }
  else
    nil
  end
end