# frozen_string_literal: true

module Crypto
  module Services
    module Registration
      class << self
        def register(email:, password:)
          User.create!(email: email, encrypted_password: encrypt_password(password))
        end

        private

        def encrypt_password(password)
          BCrypt::Password.create(password)
        end
      end
    end
  end
end
