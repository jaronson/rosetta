module Rosetta
  module Sphinx
    class ConfigGenerator
      attr_reader :template_path
      attr_reader :template_file

      def initialize
        @template_path = File.join(File.dirname(__FILE__), '../templates')
        @template_file = 'sphinx.config.erb'
      end

      def build(target_file, locals = {})
        locals = {
          :db      => build_db,
          :sources => build_sources
        }.merge(locals)

        view = ActionView::Base.new(@template_path, locals)

        File.open(target_file, 'w') do |file|
          file.write(view.render(:file => @template_file))
        end
      end

      def build_sources
        Rosetta::Concern::Localizable.includers.map do |model|
          table = model.table_name
          {
            :name    => table,
            :table   => table,
            :id_col  => "`#{table}`.`id`",
            :localized_attributes => model.localized_attributes
          }
        end
      end

      def build_db
        {
          :host     => '',
          :username => '',
          :password => '',
          :database => ''
        }
      end
    end
  end
end
