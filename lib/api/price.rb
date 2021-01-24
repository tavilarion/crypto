# frozen_string_literal: true

module Crypto
  class Price < ::Grape::API
    namespace :price do
      desc 'Get current bitcoin price', {
        headers: {
          'Authorization' => {
            description: 'Validates your identity. (Bearer: <token>)',
            required: true
          }
        }
      }

      get do
        present :bitcoin, Services::RedisClient.get('bitcoin_price')
      end
    end
  end
end
