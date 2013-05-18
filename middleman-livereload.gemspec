# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "middleman-livereload/version"

Gem::Specification.new do |s|
  s.name = "middleman-livereload"
  s.version = Middleman::LiveReload::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ["Thomas Reynolds"]
  s.email = ["me@tdreyno.com"]
  s.homepage = "https://github.com/middleman/middleman-livereload"
  s.summary = %q{LiveReload support for Middleman}
  s.description = %q{LiveReload support for Middleman}
  s.license = "MIT"
  s.files = `git ls-files -z`.split("\0")
  s.test_files = `git ls-files -z -- {fixtures,features}/*`.split("\0")
  s.require_paths = ["lib"]
  s.add_dependency("middleman-core", [">= 3.0.2"])
  s.add_runtime_dependency('rack-livereload')
  s.add_runtime_dependency('em-websocket', ['>= 0.2.0'])
  s.add_runtime_dependency('multi_json', ['~> 1.0'])
end