# encoding: utf-8
$:.push File.join(File.dirname(__FILE__),'lib')

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'rack/throttle'
require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "improved-rack-throttle"
  gem.version = Rack::Throttle::VERSION
  gem.homepage = "http://github.com/bensomers/improved-rack-throttle"
  gem.license = "Public Domain"
  gem.summary = %Q{HTTP request rate limiter for Rack applications.}
  gem.description = %Q{Rack middleware for rate-limiting incoming HTTP requests.}
  gem.email = "somers.ben@gmail.com"
  gem.authors = ["Ben Somers", "Arto Bendiken", "Brendon Murphy"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "improved-rack-throttle #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)
task :default => :spec
