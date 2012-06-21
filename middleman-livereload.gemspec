# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "middleman-livereload/version"

Gem::Specification.new do |s|
  s.name        = "middleman-livereload"
  s.version     = Middleman::LiveReload::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Thomas Reynolds"]
  s.email       = ["me@tdreyno.com"]
  s.homepage    = "https://github.com/tdreyno/middleman-livereload"
  s.summary     = %q{Adds LiveReload to Middleman}
  s.description = %q{Adds LiveReload to Middleman}

  s.rubyforge_project = "middleman-livereload"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_runtime_dependency("middleman", ["~> 3.0.0.rc"])
  s.add_runtime_dependency('em-websocket', ['>= 0.2.0'])
  s.add_runtime_dependency('multi_json', ['~> 1.3.6'])
  s.add_development_dependency("rake")
end
