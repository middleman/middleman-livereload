module Middleman
  module Livereload
    class << self
      def registered(app, options={})
        app.send :include, InstanceMethods
        
        options = {
          :api_version => '1.6',
          :host => '0.0.0.0',
          :port => '35729',
          :apply_js_live => true,
          :apply_css_live => true,
          :grace_period => 0
        }.update(options)

        app.after_configuration do
          reactor(options)
        end

        app.ready do
          files.changed do |path|
            @reactor.reload_browser(path)
          end
        end
      end
      alias :included :registered

    end 

    module InstanceMethods  
      def reactor(options)
        @reactor ||= Reactor.new(options)
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

    private
  
      def start_threaded_reactor(options)
        Thread.new do
          EventMachine.run do
            puts "LiveReload #{options[:api_version]} is waiting for a browser to connect."
            EventMachine::WebSocket.start(:host => options[:host], :port => options[:port]) do |ws|
              ws.onopen do
                begin
                  puts "Browser connected."
                  ws.send "!!ver:#{options[:api_version]}"
                  @web_sockets << ws
                rescue
                  puts $!
                  puts $!.backtrace
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