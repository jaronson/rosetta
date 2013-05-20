# encoding: utf-8
$TESTING=true
require 'rubygems'
require 'bundler/setup'
require 'rails/all'
require 'rspec/rails'

Bundler.setup(:default)

require 'rosetta'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.mock_framework = :mocha
end
