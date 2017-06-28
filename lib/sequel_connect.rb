require_relative 'sequel_connect/version'
require_relative 'sequel_connect/exceptions'
require_relative 'sequel_connect/default'

require 'pathname'
require 'yaml'
require 'rbconfig'
require 'erb'

require 'sequel'

module SequelConnect
  def filename=(fn)
    @filename = fn
  end

  def filename
    @filename ||= File.join('.', 'config', 'database.yml')
  end

  def db_config
    @db_config ||= begin
      config_file = Pathname(filename)
      raise SequelConnect::MissingConfigFileError, "#{config_file.expand_path} not found!" unless File.exist?(config_file)
      erb = ERB.new(File.read(config_file))
      YAML.load(erb.result)
    end
  end

  def stage
    s = ENV['DB_STAGE']
    raise SequelConnect::MissingStageError, "Missing environment variable `DB_STAGE'" if s.nil?
    s.downcase
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

  def DB
    @db ||= begin
      @db = Sequel.connect(current_config)
      begin
        raise unless @db.test_connection
      rescue => ex
        raise ex.message
      end
      @db
    end
  end
end
