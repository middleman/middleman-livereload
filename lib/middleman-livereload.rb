require 'em-websocket'
require 'multi_json'

Middleman::Extensions.register(:livereload) do
  require "middleman-livereload/extension"
  Middleman::Livereload
end
