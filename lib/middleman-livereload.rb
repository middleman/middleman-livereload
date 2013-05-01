require "middleman-core"
require "middleman-livereload/version"
  
::Middleman::Extensions.register(:livereload) do
  if defined?(::Middleman::Extension)
    require "middleman-livereload/extension_3_1"
    ::Middleman::LiveReloadExtension
  else
    require "middleman-livereload/extension_3_0"
    ::Middleman::LiveReload
  end
end
