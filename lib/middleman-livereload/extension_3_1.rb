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
    option :js_port, nil, 'Port to connect the LiveReload Javascript to (if different than :port)'
    option :js_host, nil, 'Host to connect LiveReload Javascript to (if different than :host)'
    option :livereload_css_target, 'stylesheets/all.css', 'CSS file to load when a @imported CSS partials are modified'
    option :livereload_css_pattern, Regexp.new('_.*\.css'), 'Regexp matching filenames that trigger live reloading target'
    option :wss_certificate, nil, 'Path to an X.509 certificate to use for the websocket server'
    option :wss_private_key, nil, 'Path to an RSA private key for the websocket certificate'

    def initialize(app, options_hash={}, &block)
      super

      if app.respond_to?(:server?)
        return unless app.server?
      else
        return unless app.environment == :development
      end

      port = options.port.to_i
      host = options.host
      js_port = options.js_port || port
      js_host = options.js_host || host
      no_swf = options.no_swf
      ignore = options.ignore
      options_hash = options.to_h
      livereload_css_target = options.livereload_css_target
      livereload_css_pattern = options.livereload_css_pattern

      extension = self

      app.ready do
        reactor = ::Middleman::LiveReload::Reactor.create(options_hash, self)

        ignored = lambda do |file|
          return true if app.files.respond_to?(:ignored?) && app.files.send(:ignored?, file)
          ignore.any? { |i| file.to_s.match(i) }
        end

        app.files.changed do |file|
          next if ignored.call(file)

          logger.debug "LiveReload: File changed - #{file}"

          reload_path = "#{Dir.pwd}/#{file}"

          file_url = app.sitemap.file_to_path(file)
          if file_url
            file_resource = app.sitemap.find_resource_by_path(file_url)
            if file_resource
              reload_path = file_resource.url
            end
          end

          # handle imported partials
          # load target file instead of triggering full page refresh
          if livereload_css_pattern.match(file.to_s) and not livereload_css_target.nil?
            logger.info("LiveReload: CSS import changed, reloading target")
            reload_path = livereload_css_target
          end

          reactor.reload_browser(reload_path)
        end

        app.files.deleted do |file|
          next if ignored.call(file)

          logger.debug "LiveReload: File deleted - #{file}"

          reactor.reload_browser("#{Dir.pwd}/#{file}")
        end

        # Use the vendored livereload.js source rather than trying to get it from Middleman
        # https://github.com/johnbintz/rack-livereload#which-livereload-script-does-it-use
        app.use ::Rack::LiveReload, port: js_port, host: js_host, no_swf: no_swf, source: :vendored, ignore: ignore
      end
    end
  end
end
