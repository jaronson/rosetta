class Rosetta::Phrase < ActiveRecord::Base
  attr_protected
  validates :key, :uniqueness => true
end
