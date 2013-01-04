# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'stdiotrap/version'

Gem::Specification.new do |gem|
  gem.name          = "stdiotrap"
  gem.version       = StdioTrap::VERSION
  gem.authors       = ["Moe"]
  gem.email         = ["moe@busyloop.net"]
  gem.description   = %q{Easily capture stdout, stderr at runtime}
  gem.summary       = %q{Easily capture stdout, stderr at runtime}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rb-inotify'
  gem.add_development_dependency 'guard'
  gem.add_development_dependency 'guard-rspec'
  gem.add_development_dependency 'simplecov'
end
