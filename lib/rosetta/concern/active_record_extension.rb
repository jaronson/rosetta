module Rosetta
  module Concern
    module ActiveRecordExtension
      extend ActiveSupport::Concern

      included do
        include Rosetta::Concern::Localizable
        include Rosetta::Concern::Translatable
      end
    end
  end
end
