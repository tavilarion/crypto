# frozen_string_literal: true

module Crypto
  module Services
    module NotificationClient
      def self.notify(user_ids)
        user_ids.each { |id| Crypto.logger.info("Threshold exceeded for user with id: #{id}") }
      end
    end
  end
end
