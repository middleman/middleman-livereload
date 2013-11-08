require 'rack/livereload'
require 'middleman-livereload/reactor'

module Middleman
  module LiveReload
    class << self
      @@reactor = nil

      def registered(app, options={})
        options = {
          :api_version => '1.6',
          :host => '0.0.0.0',
          :port => '35729',
          :apply_js_live => true,
          :apply_css_live => true,
          :grace_period => 0,
          :no_swf => false
        }.merge(options)

        app.ready do
          # Doesn't make sense in build
          if environment != :build
            if @@reactor
              @@reactor.app = self
            else
              @@reactor = Reactor.new(options, self)
            end

            files.changed do |file|
              next if ignore_manager.ignored?(file)

              sleep options[:grace_period]
              sitemap.ensure_resource_list_updated!

              begin
                file_url = sitemap.file_to_path(file)
                file_resource = sitemap.find_resource_by_path(file_url)
                reload_path = file_resource.destination_path
              rescue
                reload_path = "#{Dir.pwd}/#{file}"
              end
              @@reactor.reload_browser(reload_path)
            end

            files.deleted do |file|
              next if ignore_manager.ignored?(file)

              sleep options[:grace_period]
              sitemap.ensure_resource_list_updated!
              @@reactor.reload_browser("#{Dir.pwd}/#{file}")
            end

            use ::Rack::LiveReload, :port => options[:port].to_i, :host => options[:host], :no_swf => options[:no_swf]
          end
        end
      end
      alias :included :registered
    end
  end
end
