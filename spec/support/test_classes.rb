module Rosetta
  module Test
  end
end

class Rosetta::Test::LocalizableModel
  include Rosetta::Concern::Localizable

  attr_accessor :name
  attr_accessor :description
end
