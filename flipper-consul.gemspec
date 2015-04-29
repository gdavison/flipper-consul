# coding: utf-8
#lib = File.expand_path('../lib', __FILE__)
#$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
#require 'flipper/consul/version'
require File.expand_path('../lib/flipper/adapters/consul/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = "flipper-consul"
  spec.version       = Flipper::Adapters::Consul::VERSION
  spec.authors       = ["Graham Davison"]
  spec.email         = ["g.m.davison@computer.org"]
  spec.summary       = %q{Consul adapter for Flipper}
  spec.description   = %q{Consul adapter for Flipper}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  #spec.require_paths = ["lib"]
  
  spec.add_dependency 'flipper',  '~> 0.7.0.beta4'
  spec.add_dependency 'diplomat', '~> 0.6.1'
end
