# frozen_string_literal: true

module Crypto
  module Services
    module TokenProvider
      SECRET = Crypto.config[:secret_key_base]
      ALGORITHM = 'HS256'
      ISSUER = 'CRYPTO'
      # default one day
      EXPIRATION = 24 * 3600

      class << self
        def issue(payload)
          JWT.encode(add_metadata(payload), SECRET, ALGORITHM)
        end

        def validate(token)
          JWT.decode(token, SECRET, true, { algorithm: ALGORITHM }).first
        rescue JWT::DecodeError => e
          raise Errors::TokenInvalid, e
        end

        def jwt_for(user)
          issue(
            user_id: user.id,
            email: user.email
          )
        end

        private

        def add_metadata(payload)
          current_time = Time.now

          payload.merge({
                          exp: (current_time + EXPIRATION).to_i, # expiry
                          iss: ISSUER, # issuer
                          jti: SecureRandom.uuid, # token identifier
                          iat: current_time.to_i # issued at
                        })
        end
      end
    end
  end
end
