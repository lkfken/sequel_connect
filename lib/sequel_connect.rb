require_relative 'sequel_connect/version'
require_relative 'sequel_connect/exceptions'

require 'pathname'
require 'yaml'
require 'rbconfig'
require 'erb'

require 'sequel'

module SequelConnect
  def DB
    @DB ||= Sequel.connect(SequelConnect.current_config)
  end

  begin
    raise unless DB.test_connection
  rescue => ex
    puts ex.message
  end

  module_function

  def db_config
    filename    = File.join('.', 'config', 'database.yml')
    config_file = Pathname(filename)
    raise SequelConnect::MissingConfigFileError, "#{config_file.expand_path} not found!" unless File.exist?(config_file)
    erb = ERB.new(File.read(config_file))
    YAML.load(erb.result)
  end

  def stage
    ENV['STAGE'].downcase
  end

  def ruby_implementation
    RbConfig::CONFIG['RUBY_INSTALL_NAME'] # 'ruby', 'jruby', etc
  end

  def current_config
    db_config[ruby_implementation][stage]
  end

  def adapter
    current_config['adapter']
  end

end
