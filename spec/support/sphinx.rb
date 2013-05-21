RSpec.configure do |config|
  config.before(:suite) do
    unless defined?(SPHINX)
      # Give Riddle a dummy configuration so we can use it to control searchd.
      r_config = Riddle::Configuration.new
      r_config.searchd.pid_file = 'tmp/searchd.pid'
      r_config.searchd.log = 'tmp/searchd.log'

      # Create a Riddle controller.
      SPHINX = Riddle::Controller.new(r_config, File.join(File.dirname(__FILE__), 'test.sphinx.conf'))
    end

    # Build an initial index.
    SPHINX.index

    # Start searchd.
    SPHINX.start

    until SPHINX.running? do
      sleep 0.1
    end
  end

  config.after(:suite) do
    if defined?(SPHINX)
      # Stop searchd after specs run.
      SPHINX.stop

      while SPHINX.running? do
        sleep 0.1
        SPHINX.stop
      end
    end
  end
end
