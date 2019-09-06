# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jsender/version'

Gem::Specification.new do |spec|
  spec.name          = "jsender"
  spec.version       = Jsender::VERSION
  spec.authors       = ["Ernst Van Graan", "xneelo (Pty) Ltd"]
  spec.email         = ["seals@hetzner.co.za"]

  spec.summary       = %q{JSender facilitates a simple jsend implementation for ruby}
  spec.description   = %q{JSender facilitates a simple jsend implementation for ruby with json and rack helpers}
  spec.homepage      = "https://github.com/hetznerZA/jsender"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ['>=2.0.0']

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'byebug'
end
