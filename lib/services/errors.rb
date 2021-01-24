# frozen_string_literal: true

module Crypto
  module Services
    module Errors
      class Unauthorized < StandardError; end

      class TokenInvalid < StandardError; end
    end
  end
end
