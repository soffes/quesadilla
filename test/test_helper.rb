require 'rubygems'
require 'bundler'
Bundler.require :test

require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require 'quesadilla'

# Support files
Dir["#{File.expand_path(File.dirname(__FILE__))}/support/*.rb"].each do |file|
  require file
end

class Quesadilla::TestCase < MiniTest::Unit::TestCase
  include Quesadilla
end
