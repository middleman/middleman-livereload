require 'rack/livereload'
require 'middleman-livereload/reactor'

module Middleman
  class LiveReloadExtension < Extension
    option :host, '0.0.0.0', 'Host to bind LiveReload API server to'
    option :port, '35729', 'Port to bind the LiveReload API server to'
    option :apply_js_live, true, 'Apply JS changes live, without reloading'
    option :apply_css_live, true, 'Apply CSS changes live, without reloading'
    option :grace_period, 0, 'Time (in seconds) to wait before reloading'
    option :no_swf, false, 'Disable Flash WebSocket polyfill for browsers that support native WebSockets'

    def initialize(app, options_hash={}, &block)
      super

      # Doesn't make sense in build
      return if app.environment == :build

      @reactor = nil

      grace_period = options.grace_period
      port = options.port.to_i
      host = options.host
      no_swf = options.no_swf
      options_hash = options.to_h

      app.ready do
        if @reactor
          @reactor.app = self
        else
          @reactor = ::Middleman::LiveReload::Reactor.new(options_hash, self)
        end

        files.changed do |file|
          next if ignore_manager.ignored?(file)

          sleep(grace_period) if grace_period > 0
          sitemap.ensure_resource_list_updated!
          puts "Changed! #{file}"

          begin
            file_url = sitemap.file_to_path(file)
            file_resource = sitemap.find_resource_by_path(file_url)
            reload_path = file_resource.destination_path
          rescue
            reload_path = "#{Dir.pwd}/#{file}"
          end
          @reactor.reload_browser(reload_path)
        end

        files.deleted do |file|
          next if ignore_manager.ignored?(file)

          sleep(grace_period) if grace_period > 0
          sitemap.ensure_resource_list_updated!
          puts "Deleted! #{file}"

          @reactor.reload_browser("#{Dir.pwd}/#{file}")
        end

        use ::Rack::LiveReload, :port => port, :host => host, :no_swf => no_swf
      end
    end
  end
end
