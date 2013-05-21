require 'active_support/concern'
require 'active_support/core_ext'

module Rosetta
  module Concern
    class InclusionTracker
      @@direct_includers = Hash.new {|h,k| h[k] = [] }

      def self.direct_includers(mod)
        @@direct_includers[mod]
      end
    end

    def self.extended(base)
      base.define_singleton_method(:includers) do
        InclusionTracker.direct_includers(self)
      end

      base.define_singleton_method(:add_includer) do |base|
        InclusionTracker.direct_includers(self) << base
      end

      super
    end

    def includers
      InclusionTracker.includers(self)
    end
  end
end

require 'rosetta/concern/localizable'
require 'rosetta/concern/translatable'
require 'rosetta/concern/active_record_extension'
require 'rosetta/concern/phrase_key'
