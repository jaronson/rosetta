require 'i18n/backend/base'
require 'i18n/backend/flatten'

module I18n::Backend
  class ActiveRecord
    include Base, Flatten

    def initialize(options = {})
      @memoize = options[:memoize] ? true : false
    end

    def available_locales
      memoized_locales.keys
    end

    def reset!
      @memoized_locales      = nil
      @memoized_translations = nil
    end

    def memoize?
      @memoize
    end

    def store_translations(locale, data, options = {})
      locale = Locale.find_or_create_by_name(locale)
      flatten_translations(locale.name, data, nil, nil).stringify_keys.each do |key, text|
        phrase = Phrase.find_or_create_by_key(key)

        if !Translation.find_by_locale_id_and_phrase_id(locale.id, phrase.id)
          Translation.create!(:locale_id => locale.id, :phrase_id => phrase.id, :text => text)
        end
      end
    end

    protected
    def lookup(locale, key, scope = [], options = {})
      key = normalize_flat_keys(locale, key, scope, options[:separator])

      if memoize?
        available_locales
        return nil unless memoized_locales.present?

        result = memoized_translations[locale.to_sym][key]
        return result if result

        result = lookup_from_database(locale, key)
        memoized_translations[locale.to_sym][key] = result
      else
        lookup_from_database(locale, key)
      end
    end

    def lookup_from_database(locale, key)
      locale      = ::Locale.find_by_name(locale)
      translation = ::Translation.by_locale_id_and_key(locale.id, key)
      translation ? translation.text : nil
    end

    def memoized_locales
      @memoized_locales ||= {}.tap do |locales|
        ::Locale.all.each{|l| locales[l.name.to_sym] = l.id }
      end
    end

    def memoized_translations
      @memoized_translations ||= {}.tap do |translations|
        available_locales.each{|n| translations[n] = {}}
      end
    end
  end
end
