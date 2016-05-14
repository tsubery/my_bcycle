# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'my_bcycle/version'

Gem::Specification.new do |spec|
  spec.name          = "my_bcycle"
  spec.version       = MyBcycle::VERSION
  spec.authors       = ["Gal Tsubery"]
  spec.email         = ["gal.tsubery@gmail.com"]

  spec.summary       = "Wrapper of bcycle personal usage statistics API"
  spec.description   = "This gem retrieves bcycle personal usage statistics from their website, including total miles, duration and money saved."
  spec.homepage      = "http://github.com/tsubery/my_bcycle/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 2.0"
  spec.add_dependency "typhoeus", "~> 1.0"
end
