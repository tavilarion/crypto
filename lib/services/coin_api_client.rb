# frozen_string_literal: true

module Crypto
  module Services
    module CoinApiClient
      API_URL = Crypto.config[:coin_api]

      def self.fetch_bitcoin_price
        query = { 'ids' => 'bitcoin', 'vs_currencies' => 'usd' }

        response = HTTParty.get(API_URL, query: query)

        response['bitcoin']['usd'].to_f
      end
    end
  end
end
