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

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "uakari"
  gem.homepage = "http://github.com/amro/uakari"
  gem.license = "MIT"
  gem.summary = %Q{Uakari a API wrapper for the MailChimp STS API (1.0)}
  gem.description = %Q{Uakari a API wrapper for the MailChimp STS API (1.0), which wraps Amazon SES.}
  gem.email = "amromousa@gmail.com"
  gem.authors = ["Amro Mousa"]

  gem.add_runtime_dependency 'httparty', '> 0.6.0'
  gem.add_runtime_dependency 'json', '>= 1.4.0'
  gem.add_runtime_dependency 'actionmailer', '>= 3.0.0'
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

require 'rcov/rcovtask'
Rcov::RcovTask.new do |test|
  test.libs << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "uakari #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
