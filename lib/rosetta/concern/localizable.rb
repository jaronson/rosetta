module Rosetta
  module Concern
    module Localizable
      extend Rosetta::Concern
      extend ActiveSupport::Concern

      included do
        delegate :localizes?, :to => 'self.class'
      end

      module ClassMethods
        def localized_attributes
          @localized_attributes ||= {}
        end

        def localizes?(attr)
          localized_attributes.keys.include?(attr)
        end

        def localizes(*args)
          Rosetta::Concern::Localizable.add_includer(self)
          define_localizables(*args)
        end

        protected
        def define_localizables(*args)
          attr_opts = args.extract_options!
          attrs     = args

          attrs.each do |attr|
            if self.respond_to?(:columns_hash)
              attr_opts[:column_attributes] = columns_hash[attr.to_s]
            end

            localized_attributes[attr] = attr_opts
            define_localized_attr(attr, attr_opts)
          end
        end

        def define_localized_attr(name, opts)
          define_method("localized_#{name}") do |*args, &block|
            opts = args.extract_options!
            localized_attr_value(name, opts, &block)
          end
        end
      end

      def phrase_key(attr, opts = {})
        raise Rosetta::LocalizedAttributeMissingError.new(self, attr) if !localizes?(attr)
        Rosetta::Concern::PhraseKey.new(self, attr)
      end

      private
      def localized_attr_value(attr, options, &block)
        locale = options[:locale] || I18n.default_locale
        key    = phrase_key(attr)

        # Get the entry for the given locale
        entry      = translate_localized_attr(locale, key)
        top_lookup = entry

        # If the locale is secondary and we're falling back to the primary, get the primary
        if untranslated?(entry) && locale != I18n.default_locale
          entry = translate_localized_attr(I18n.default_locale, key)
        end

        # If we don't have the default key, we have an id, and it's untranslated, get the default
        if untranslated?(entry) && respond_to?(:id) && !key.is_default?
          key   = phrase_key(attr, :force_default => true)
          entry = translate_localized_attr(locale, key)
        end

        # If not the default, and this object has a value for the attr, use it
        if untranslated?(entry) && !key.is_default? && !send(attr).nil?
          entry = send(attr)
        end

        if block_given?
          yield untranslated?(entry) ? nil : entry
        else
          untranslated?(entry) ? top_lookup.message : entry
        end
      end

      def translate_localized_attr(locale, key)
        translation = catch(:exception) do
          I18n.backend.translate(locale, key.to_s)
        end
      end

      def untranslated?(entry)
        entry.is_a?(I18n::MissingTranslation)
      end
    end
  end
end
