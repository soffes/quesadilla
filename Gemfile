source 'https://rubygems.org'

# Gem dependencies
gemspec

gem 'rake', :group => [:development, :test]

# Development dependencies
group :development do
  gem 'yard'
  gem 'redcarpet', :platform => 'ruby'
end

# Testing dependencies
group :test do
  gem 'minitest'
  gem 'minitest-wscolor' if RUBY_VERSION >= '1.9.3'
  gem 'simplecov', :require => false
end
