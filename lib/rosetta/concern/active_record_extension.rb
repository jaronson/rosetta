module Rosetta
  module Concern
    module ActiveRecordExtension
      extend ActiveSupport::Concern

      included do
        include Rosetta::Concern::Localizable
      end
    end
  end
end
