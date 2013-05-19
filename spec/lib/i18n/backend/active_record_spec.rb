require 'spec_helper'

describe I18n::Backend::ActiveRecord do
  let(:backend){ I18n::Backend::ActiveRecord.new }

  let!(:locales){[
    Locale.generate!(:name => 'en'),
    Locale.generate!(:name => 'es'),
    Locale.generate!(:name => 'fr')
  ]}

  describe '#available_locales' do
    it 'should return an array of names as symbols' do
      backend.available_locales.should eql [ :en, :es, :fr ]
    end

    describe 'memoization' do
      it 'should memoize locales' do
        Locale.expects(:all).once.returns([])

        backend.available_locales
        backend.available_locales
      end
    end
  end

  describe '#lookup' do
    let(:backend){ I18n::Backend::ActiveRecord.new(:memoize => true) }
    let(:key)    { 'users.edit.login' }
    let!(:phrase){ Phrase.generate!(:key => key) }
    let(:lookup!){ backend.send(:lookup, 'en', key) }

    context 'translation present for locale and key' do
      let!(:translation){ Translation.generate!({
        :locale_id => locales.first.id,
        :phrase_id => phrase.id,
        :text      => 'Login'
      })}

      it 'should return the translation text' do
        lookup!.should eql 'Login'
      end

      describe 'memoization' do
        it 'should memoize translations' do
          lookup!.should eql 'Login'

          Translation.expects(:by_locale_id_and_key).never
          lookup!.should eql 'Login'
          backend.send(:memoized_translations)[:en].should eql({ key => 'Login' })
        end
      end
    end
  end
end
