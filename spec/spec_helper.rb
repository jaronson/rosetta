# encoding: utf-8
$TESTING=true
require 'rubygems'
require 'bundler/setup'
require 'rails/all'
require 'rspec/rails'
require 'thebes'

ActiveRecord::Base.logger = Logger.new('tmp/ar_debug.log')
ActiveRecord::Base.configurations = YAML::load(IO.read('spec/support/database.yml'))
ActiveRecord::Base.establish_connection('test')

Bundler.setup(:default)

require 'rosetta'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :mocha
  config.use_transactional_fixtures = false

  config.after(:each) do
    ActiveRecord::Base.connection.execute('SHOW TABLES').each do |table|
      next if table.index('schema_migrations') || table.index('roles')
      ActiveRecord::Base.connection.execute("TRUNCATE #{table.first}")
    end
  end
end
