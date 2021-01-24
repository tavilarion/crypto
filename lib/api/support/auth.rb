# frozen_string_literal: true

module Crypto
  module Support
    module Auth
      def verify_token
        params[:_client] = Services::TokenProvider.validate(request_token).deep_symbolize_keys
      rescue Services::Errors::TokenInvalid
        unauthorized!('Token invalid')
      end

      def request_token
        auth_header = headers['Authorization']
        unauthorized!('Token invalid') if auth_header.blank?
        auth_header.split(' ').last
      end
    end
  end
end
