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
  end
end