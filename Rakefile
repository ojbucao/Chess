require 'rspec/core/rake_task'

desc "Run the specs."
task :default => :spec

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = "spec/**/*_spec.rb"
end
