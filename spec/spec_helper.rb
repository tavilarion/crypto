ENV['RACK_ENV'] = 'test'

require 'rack/test'
require_relative '../config/boot'
require 'ostruct'

ActiveRecord::Base.logger.level = Logger::INFO

Utils.load_files %w[
  spec/support/*.rb
]

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.include Rack::Test::Methods

  config.include Support::Request

  config.before(:each) do
    # disable logging
    allow(Crypto).to receive(:logger).and_return(Support::LoggerStub)
  end

  config.before(:suite) do
    FactoryBot.find_definitions
  end

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end

def app
  Crypto::Core
end
