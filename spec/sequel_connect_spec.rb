require 'dotenv'
Dotenv.load!
require 'rspec'
require_relative '../lib/sequel_connect'

describe SequelConnect do
  context 'specify database.yml file location' do
    it 'should have the file location' do
      SequelConnect.filename = File.join('.', 'some_config', 'database.yml')
      expect(SequelConnect.filename).to eq('./some_config/database.yml')
    end
    it 'should have the default location for database.yml' do
      SequelConnect.filename = nil #reset
      expect(SequelConnect.filename).to eq('./config/database.yml')
    end
    it 'should take the db config' do
      SequelConnect.db_config = {adapter: 'jdbc', database: 'jtds:sqlserver://db_server/database;user=john;password=secret'}
      expect(SequelConnect.db_config).to eq({adapter: 'jdbc', database: 'jtds:sqlserver://db_server/database;user=john;password=secret'})
    end
    it 'should have current config based from platform and stage' do
      config = <<~CONFIG
        ---
        jruby:
          test:
            :adapter: jdbc
            :database: jtds:sqlserver://db_server/database;user=john;password=secret
      CONFIG
      SequelConnect.db_config = YAML::load(config)
      SequelConnect.stage = 'test'
      expect(SequelConnect.current_config).to eq({adapter: 'jdbc', database: 'jtds:sqlserver://db_server/database;user=john;password=secret'})
    end
  end
end