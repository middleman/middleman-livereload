require 'bundler/gem_tasks'

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
end

task :test => ["spec"]

desc "Build HTML documentation"
task :doc do
  sh 'bundle exec yard'
end
