class Rosetta::Translation < ActiveRecord::Base
  belongs_to :phrase

  validates :phrase, :presence => true
  validates :text,   :presence => true
end
