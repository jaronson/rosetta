require 'active_record'
require 'mysql2'
require 'logger'
require 'rspec/rails/adapters'
require 'rspec/rails/fixture_support'

ROOT = File.join(File.dirname(__FILE__), '..')
template_filename  = "#{ROOT}/../lib/rails/generators/rosetta/migration/templates/create_rosetta_tables.rb"
migration_filename = "#{ROOT}/001_create_rosetta_tables.rb"

File.open(migration_filename, 'w') do |file|
  file.write(File.read(template_filename))
end

ActiveRecord::Base.logger = Logger.new('tmp/ar_debug.log')
ActiveRecord::Base.configurations = YAML::load(IO.read('spec/support/database.yml'))
ActiveRecord::Base.establish_connection('test')

ActiveRecord::Schema.define(:version => 0) do
  create_table :items, :force => true do |t|
    t.string  :name
    t.boolean :active
    t.string  :body
  end
end

ActiveRecord::Migrator.migrate([ ROOT ], 1)

class Item < ActiveRecord::Base
  localizes :name, :body
end
