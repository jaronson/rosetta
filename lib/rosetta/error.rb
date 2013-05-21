module Rosetta
  class Error < StandardError
  end

  class LocalizedAttributeMissingError < Error
    def initialize(localizable, attr)
      super("No localization defined for `#{localizable}' on attribute `#{attr}")
    end
  end
end
