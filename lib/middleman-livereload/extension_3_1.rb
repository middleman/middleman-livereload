require 'rack/livereload'
require 'middleman-livereload/reactor'

module Middleman
  class LiveReloadExtension < Extension
    option :port, '35729', 'Port to bind the LiveReload API server to'
    option :apply_js_live, true, 'Apply JS changes live, without reloading'
    option :apply_css_live, true, 'Apply CSS changes live, without reloading'
    option :no_swf, false, 'Disable Flash WebSocket polyfill for browsers that support native WebSockets'
    option :host, Socket.ip_address_list.find(->{ Addrinfo.ip 'localhost' }, &:ipv4_private?).ip_address, 'Host to bind LiveReload API server to'

    def initialize(app, options_hash={}, &block)
      super

      return unless app.environment == :development

      @reactor = nil

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
          next if files.send(:ignored?, file)

          logger.debug "LiveReload: File changed - #{file}"

          reload_path = "#{Dir.pwd}/#{file}"

          file_url = sitemap.file_to_path(file)
          if file_url
            file_resource = sitemap.find_resource_by_path(file_url)
            if file_resource
              reload_path = file_resource.url
            end
          end

          @reactor.reload_browser(reload_path)
        end

        files.deleted do |file|
          next if files.send(:ignored?, file)

          logger.debug "LiveReload: File deleted - #{file}"

          @reactor.reload_browser("#{Dir.pwd}/#{file}")
        end

        # Use the vendored livereload.js source rather than trying to get it from Middleman
        # https://github.com/johnbintz/rack-livereload#which-livereload-script-does-it-use
        use ::Rack::LiveReload, :port => port, :host => host, :no_swf => no_swf, :source => :vendored
      end
    end
  end
end
