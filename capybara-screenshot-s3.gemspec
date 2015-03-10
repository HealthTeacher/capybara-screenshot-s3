# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "capybara-screenshot-s3/version"

Gem::Specification.new do |s|
  s.name        = "capybara-screenshot-s3"
  s.version     = Capybara::Screenshot::S3::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Mark Wise"]
  s.email       = ["markmediadude@gmail.com"]
  s.homepage    = "http://github.com/HealthTeacher/capybara-screenshot-s3"
  s.summary     = %q{Post screenshots from capybara-screenshots to Amazon S3}
  s.description = %q{Automatically upload failing spec screenshots to S3}
  s.license     = 'MIT'

  s.rubyforge_project = "capybara-screenshot-s3"

  s.add_dependency 'capybara-screenshot', '~> 1.0.7'
  s.add_dependency 'aws-sdk', '~> 2.0'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'timecop'
  s.add_development_dependency 'cucumber'
  s.add_development_dependency 'aruba'
  s.add_development_dependency 'sinatra'
  s.add_development_dependency 'test-unit'
  s.add_development_dependency 'spinach'
  s.add_development_dependency 'minitest'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
