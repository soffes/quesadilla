require 'rubygems'
require 'bundler'
Bundler.require :test

require 'coveralls'
Coveralls.wear!

require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require 'quesadilla'

# Support files
Dir["#{File.expand_path(File.dirname(__FILE__))}/support/*.rb"].each do |file|
  require file
end

class Quesadilla::TestCase < MiniTest::Test
  include Quesadilla
end
