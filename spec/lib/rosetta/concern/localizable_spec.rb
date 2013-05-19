require 'spec_helper'

describe Rosetta::Concern::Localizable do
  let(:test_class){ Rosetta::Test::LocalizableModel }

  describe 'ClassMethods' do
    describe '#localized_attributes' do
      it 'is initialized as an empty hash' do
        test_class.localized_attributes.should eql Hash.new
      end
    end

    describe '#localizes' do
      context 'single attr given' do
        before(:each) do
          test_class.localizes(:name, :opt1 => 'value')
        end

        it 'creates a localized attr entry' do
          test_class.localized_attributes[:name].should eql({ :opt1 => 'value' })
        end

        it 'defines a localized instance method' do
          test_class.new.should respond_to(:localized_name)
        end
      end
    end

    describe '#localizes?' do
      context '@localized_attributes does not contain the given key' do
        it 'returns false' do
          test_class.localizes?(:description).should be_false
        end
      end

      context '@localized_attributes contains the given key' do
        it 'returns true' do
          test_class.localizes?(:name).should be_true
        end
      end
    end
  end

  describe 'InstanceMethods' do
    let(:instance){ Rosetta::Test::LocalizableModel.new }

    describe '#phrase_key' do
      context 'class does not localize the given attribute' do
        it 'raises an error' do
          expect {
          instance.phrase_key(:description)
          }.to raise_error(Rosetta::LocalizationError)
        end
      end

      context 'class has table_name method' do
        it 'returns a key containing the table name' do
          instance.class.stubs(:table_name).returns('items')
          instance.phrase_key(:name).to_s.should eql 'items.name'
        end
      end

      context 'class has no table_name method' do
        it 'returns a key containing the tableized class name' do
          instance.phrase_key(:name).to_s.should eql 'localizable_models.name'
        end
      end

      context 'class is subclass of ActiveRecord::Base' do
        it 'returns a key containing the record id' do
          instance.class.expects(:<).with(ActiveRecord::Base).returns(true)
          instance.stubs(:id).returns(1)
          instance.phrase_key(:name).to_s.should eql "localizable_models.1.name"
        end
      end

      context 'class is not subclass of ActiveRecord::Base' do
        it 'returns a key with no id' do
          instance.phrase_key(:name).to_s.should eql 'localizable_models.name'
        end
      end
    end

    describe '#localized_name dynamic method' do
      before(:all) do
        I18n.stubs(:default_locale).returns(:en)
      end

      let(:locale)          { :en }
      let(:attr_value)      { 'Test Record' }
      let(:instance)        { test_class.new }
      let(:key)             { 'localizable_models.name' }
      let(:default_key)     { 'localizable_models.default.name' }
      let(:translation)     { 'Test Record Primary' }
      let(:missing_message) { 'translation missing: en.localizable_models.name' }

      before(:each) do
        test_class.localizes(:name)
      end

      context 'object with identifier' do
        let(:record_id)       { 304 }
        let(:key)             { "localizable_models.#{record_id}.name" }
        let(:missing_message) { "translation missing: #{locale}.localizable_models.#{record_id}.name" }

        before(:each) do
          instance.stubs(:id).returns(record_id)
        end

        describe 'for primary locale' do
          context 'primary translation exists' do
            it 'returns the primary translation'
          end

          context 'no primary translation exists' do
            context 'default translation exists' do

              it 'returns the default translation'
            end

            context 'no default translation exists' do
              context 'attribute value is not nil' do
                it 'returns the attribute value'
              end

              context 'attribute value is nil' do
                it 'returns the missing message'
              end
            end
          end
        end
      end

      context 'object without identifier' do
      end
    end
  end
end
