# frozen_string_literal: true

module Crypto
  class Thresholds < Grape::API
    namespace :thresholds do
      #
      # Create threshold
      #
      desc 'Set thresholds', {
        headers: {
          'Authorization' => {
            description: 'Validates your identity. (Bearer: <token>)',
            required: true
          }
        }
      }

      params do
        requires :lower, type: Float, documentation: { in: 'body' }
        requires :upper, type: Float, documentation: { in: 'body' }
      end

      post do
        threshold = Threshold.create(user_id: params[:_client][:user_id], lower: params[:lower], upper: params[:upper])

        # Notify on creation if price exceeds threshold
        Services::NotificationEngine.check(threshold)

        present threshold, with: Entities::Threshold
      end
    end
  end
end
