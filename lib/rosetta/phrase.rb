class Rosetta::Phrase < ActiveRecord::Base
  validates :key, :uniqueness => true
end
