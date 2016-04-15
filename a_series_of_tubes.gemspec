# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'a_series_of_tubes/version'

Gem::Specification.new do |spec|
  spec.name          = "a_series_of_tubes"
  spec.version       = ASeriesOfTubes::VERSION
  spec.authors       = ["Dan Phillips"]
  spec.email         = ["dan@danphillips.io"]

  spec.summary       = "a web development framework"
  spec.homepage      = "http://www.github.com/rake-db-migrate/a_series_of_tubes"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_runtime_dependency "rack"
  spec.add_runtime_dependency "json"
end
