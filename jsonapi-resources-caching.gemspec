# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jsonapi-resources/caching/version'

Gem::Specification.new do |spec|
  spec.name          = "jsonapi-resources-caching"
  spec.version       = JSONAPI::Caching::VERSION
  spec.authors       = ["Will Bryant"]
  spec.email         = ["william@tout.com"]

  spec.summary       = %q{Plugin for jsonapi-resources to facilitate caching}
  spec.description   = %q{Plugin for jsonapi-resources to facilitate caching}
  spec.homepage      = "https://github.com/Tout/jsonapi-resources-caching"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_dependency 'jsonapi-resources'
  spec.add_dependency 'rails-api'

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
