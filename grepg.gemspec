# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require_relative 'lib/grepg/version'

Gem::Specification.new do |s|
  s.name        = "grepg"
  s.version     = GrepPage::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Yash Ranadive"]
  s.email       = ["yash.ranadive@gmail.com"]
  s.homepage    = "https://www.greppage.com"
  s.summary     = %q{A ruby client to access greppage.com from the commandline}
  s.description = %q{A ruby client to access greppage.com from the commandline}


  s.add_runtime_dependency 'trollop', '~> 2.1.2'
  s.add_runtime_dependency 'rest-client', '~> 1.8.0'
  s.add_runtime_dependency 'colorize', '~> 0.7.7'
  s.add_development_dependency 'rspec', "~>3.0.0"
  s.add_development_dependency 'rake', "~>10.1.0"
  s.add_development_dependency 'webmock', "~>1.21.0"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end

