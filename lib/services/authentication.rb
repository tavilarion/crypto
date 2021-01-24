# frozen_string_literal: true

module Crypto
  module Services
    class Authentication
      def initialize(email:, password:)
        @email = email
        @password = password
      end

      def authenticate
        user = User.find_by(email: email)
        raise Errors::Unauthorized if user.nil? || !valid_password?(user.encrypted_password)

        TokenProvider.jwt_for(user)
      end

      private

      attr_reader :email, :password

      def valid_password?(stored_pass)
        BCrypt::Password.new(stored_pass) == password
      end
    end
  end
end
