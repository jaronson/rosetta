# encoding: utf-8
$TESTING=true
require 'rubygems'
require 'bundler/setup'

Bundler.setup(:default)

require 'rosetta'

RSpec.configure do |config|
  config.mock_framework = :mocha
end


