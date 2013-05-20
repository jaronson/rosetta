module Rosetta
  module Generators
    class MigrationGenerator < Rails::Generator::Base
      include Rails::Generators::migration

      desc 'Creates migrations for Rosetta tables'
      source_root File.expand_path('../templates', __FILE__)

      def self.next_migration_number
        if @prev_migration_nr
          @prev_migration_number += 1
        else
          @prev_migration_number = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
        end

        @prev_migration_nr.to_s
      end

      def copy_migrations
        migration_template('create_rosetta_tables', 'db/migrate/create_rosetta_tables.rb')
      end
    end
  end
end
