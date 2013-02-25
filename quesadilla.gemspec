# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'quesadilla/version'

Gem::Specification.new do |gem|
  gem.name          = 'quesadilla'
  gem.version       = Quesadilla::VERSION
  gem.authors       = ['Sam Soffes']
  gem.email         = ['sam@soff.es']
  gem.description   = 'Entity-style text parsing'
  gem.summary       = gem.description
  gem.homepage      = 'https://github.com/soffes/quesadilla'
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.required_ruby_version = '>= 1.9.3'

  # Hashtag and autolink parsing
  gem.add_dependency 'twitter-text', '~> 1.5.0'

  # Emoji detection
  gem.add_dependency 'named_emoji', '~> 1.1.1'
end
