class Rosetta::Translation < ActiveRecord::Base
  attr_protected

  belongs_to :phrase

  validates :phrase, :presence => true
  validates :text,   :presence => true
end
