# coding: utf-8

require_relative 'sequel_connect/version'
require_relative 'sequel_connect/exceptions'
require_relative 'sequel_connect/default'

require 'pathname'
require 'yaml'
require 'rbconfig'
require 'erb'

require 'sequel'
STAGE = 'DB_STAGE'
module SequelConnect
  extend self

  def filename=(fn)
    @filename = fn
  end

  def filename
    @filename ||= File.join('.', 'config', 'database.yml')
  end

  def db_config=(config)
    @db_config = config
  end

  def db_config
    @db_config ||= begin
      config_file = Pathname(self.filename)
      raise SequelConnect::MissingConfigFileError, "#{config_file.expand_path} not found!" unless File.exist?(config_file)
      erb = ERB.new(File.read(config_file))
      YAML.load(erb.result, aliases: true)
    end
  end

  def stage=(level)
    @stage = level.to_s.downcase
  end

  def stage
    @stage ||= begin
      s = ENV[STAGE]
      raise SequelConnect::MissingStageError, "Missing environment variable `#{STAGE}'" if s.nil?
      s.downcase
    end
  end

  def ruby_implementation
    RbConfig::CONFIG['RUBY_INSTALL_NAME'] # 'ruby', 'jruby', 'ruby2.4', etc
  end

  def current_config
    @current_config ||= begin
      implementation = db_config.fetch(ruby_implementation) { |key| raise "missing #{key} platform in your configuration #{self.filename}" }
      implementation.fetch(stage) { |key| raise "missing #{key} stage" }
    end
  end

  def adapter
    current_config['adapter']
  end

  def db
    @db ||= begin
      @db = Sequel.connect(current_config)
      begin
        raise unless @db.test_connection
      rescue => ex
        raise [current_config, ex.message].join("\n")
      end
      @db
    end
  end
  alias_method :DB, :db
end
