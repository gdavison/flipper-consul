# coding: utf-8
require File.expand_path('../lib/flipper/adapters/consul/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = "flipper-consul"
  spec.version       = Flipper::Adapters::Consul::VERSION
  spec.authors       = ["Graham Davison"]
  spec.email         = ["g.m.davison@computer.org"]
  spec.summary       = %q{Consul adapter for Flipper}
  spec.description   = %q{Consul adapter for Flipper}
  spec.homepage      = "https://github.com/gdavison/flipper-consul"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})

  spec.add_dependency 'flipper',  '~> 0.9'
  spec.add_dependency 'diplomat', '>= 1.2', '< 3.0'
end
