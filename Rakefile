require 'bundler/gem_tasks'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task :test => ["spec"]

desc "Build HTML documentation"
task :doc do
  sh 'bundle exec yard'
end
