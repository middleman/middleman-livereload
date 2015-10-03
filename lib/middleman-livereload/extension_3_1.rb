require 'rack/livereload'
require 'middleman-livereload/reactor'

module Middleman
  class LiveReloadExtension < Extension
    option :port, '35729', 'Port to bind the LiveReload API server to listen to'
    option :apply_js_live, true, 'Apply JS changes live, without reloading'
    option :apply_css_live, true, 'Apply CSS changes live, without reloading'
    option :no_swf, false, 'Disable Flash WebSocket polyfill for browsers that support native WebSockets'
    option :host, Socket.ip_address_list.find(->{ Addrinfo.ip 'localhost' }, &:ipv4_private?).ip_address, 'Host to bind LiveReload API server to'
    option :ignore, [], 'Array of patterns for paths that must be ignored'
    option :bundle_file_css, 'stylesheets/application.css', 'File to load when a CSS partial was modified'
    option :js_port, nil, 'Port to connect the LiveReload Javascript to (if different than :port)'
    option :js_host, nil, 'Host to connect LiveReload Javascript to (if different than :host)'

    def initialize(app, options_hash={}, &block)
      super

      if app.respond_to?(:server?)
        return unless app.server?
      else
        return unless app.environment == :development
      end

      @reactor = nil

      port = options.port.to_i
      host = options.host
      js_port = options.js_port || port
      js_host = options.js_host || host
      no_swf = options.no_swf
      ignore = options.ignore
      bundle_file_css = options.bundle_file_css
      options_hash = options.to_h

      app.ready do
        if @reactor
          @reactor.app = self
        else
          @reactor = ::Middleman::LiveReload::Reactor.new(options_hash, self)
        end

        files.changed do |file|
          next if files.respond_to?(:ignored?) && files.send(:ignored?, file)

          logger.debug "LiveReload: File changed - #{file}"

          reload_path = "#{Dir.pwd}/#{file}"

          file_url = sitemap.file_to_path(file)
          if file_url
            file_resource = sitemap.find_resource_by_path(file_url)
            if file_resource
              reload_path = file_resource.url
            end

            unless file_resource
              if /_.*\.css/.match(file_url) and not bundle_file_css.nil?
                logger.info("CSS partial, reloading #{bundle_file_css}")
                reload_path = bundle_file_css
              end
            end

          end

          @reactor.reload_browser(reload_path)
        end

        files.deleted do |file|
          next if files.respond_to?(:ignored?) && files.send(:ignored?, file)

          logger.debug "LiveReload: File deleted - #{file}"

          @reactor.reload_browser("#{Dir.pwd}/#{file}")
        end

        # Use the vendored livereload.js source rather than trying to get it from Middleman
        # https://github.com/johnbintz/rack-livereload#which-livereload-script-does-it-use
        use ::Rack::LiveReload, port: js_port, host: js_host, no_swf: no_swf, source: :vendored, ignore: ignore
      end
    end
  end
end
