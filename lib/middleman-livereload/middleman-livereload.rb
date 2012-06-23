require "middleman-core"
require "middleman-livereload/version"
  
::Middleman::Extensions.register(:livereload) do
  require "middleman-livereload/extension"
  ::Middleman::LiveReload
end