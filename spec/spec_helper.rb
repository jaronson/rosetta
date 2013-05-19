# encoding: utf-8
$TESTING=true
require 'rubygems'
require 'bundler/setup'

Bundler.setup(:default)

require 'rosetta'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.mock_framework = :mocha
end
