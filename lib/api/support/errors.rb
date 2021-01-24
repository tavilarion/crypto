# frozen_string_literal: true

module Crypto
  module Support
    module Errors
      def unauthorized!(message = 'Unauthorized', code: 401)
        error!({ code: code, message: message }, code)
      end

      def validation_failed!(message = 'Request invalid', code: 422)
        error!({ code: code, message: message }, code)
      end

      def forbidden!(message = 'Forbidden', code: 403)
        error!({ code: code, message: message }, code)
      end
    end
  end
end
