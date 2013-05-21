require 'spec_helper'

describe Rosetta::Sphinx::ConfigGenerator do
  let(:generator)   { Rosetta::Sphinx::ConfigGenerator.new }
  let(:target_file) { File.join(ROOT, 'support','test.sphinx.conf') }
  let(:db_conf)     { YAML.load_file(File.join(ROOT, 'support','database.yml'))['test'].symbolize_keys! }

  it 'should write the template file' do
    generator.build(target_file, :db => db_conf)
  end


  describe 'searching' do
    let(:item)        { Item.create(:name => 'test item', :body => 'test body') }
    let(:phrase)      { Rosetta::Phrase.create!(:key => "items.#{item.id}.name") }
    let(:translation) { Rosetta::Translation.create!(:locale => 'en', :phrase => phrase, :text => 'test item') }

    before(:each) do
      item
      phrase
      translation
    end

    it 'should return matches' do
      SPHINX.index
      Thebes::Query.servers = [[ 'localhost', 9333 ]]
      result = Thebes::Query.run do |q|
        q.append_query('test', 'items')
      end
    end
  end
end
