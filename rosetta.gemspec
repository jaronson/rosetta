# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rosetta/version'

Gem::Specification.new do |spec|
  spec.name          = 'rosetta'
  spec.version       = Rosetta::VERSION
  spec.authors       = ['Josh Aronson']
  spec.email         = ['jparonson@gmail.com']
  spec.description   = %q{ActiveRecord Localization}
  spec.summary       = %q{Make your ActiveRecord objects translatable, editable, and searchable}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport'
  spec.add_dependency 'i18n'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'mocha'
end
