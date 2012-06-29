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
          return if environment == :build

          reactor = Reactor.new(options)
          
          files.changed { |file| reactor.reload_browser(file) }
          files.deleted { |file| reactor.reload_browser(file) }

          use ::Rack::LiveReload
        end
      end
      alias :included :registered
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
        paths = Array(paths)
        puts "Reloading browser: #{paths.join(' ')}"
        paths.each do |path|
          data = MultiJson.encode(['refresh', {
            :path           => "#{Dir.pwd}/#{path}",
            :apply_js_live  => @options[:apply_js_live],
            :apply_css_live => @options[:apply_css_live]
          }])
          # UI.debug data
          @web_sockets.each { |ws| ws.send(data) }
        end
      end

      def start_threaded_reactor(options)
        Thread.new do
          EventMachine.run do
            puts "LiveReload #{options[:api_version]} is waiting for a browser to connect."
            EventMachine.start_server(options[:host], options[:port], EventMachine::WebSocket::Connection, {}) do |ws|
              ws.onopen do
                begin
                  ws.send "!!ver:#{options[:api_version]}"
                  @web_sockets << ws
                  puts "Browser connected."
                rescue
                  $stderr.puts $!
                  $stderr.puts $!.backtrace
                end
              end

              ws.onmessage do |msg|
                puts "Browser URL: #{msg}"
              end

              ws.onclose do
                @web_sockets.delete ws
                puts "Browser disconnected."
              end
            end
          end
        end
      end
    end
  end
end
