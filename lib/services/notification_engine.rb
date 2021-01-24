# frozen_string_literal: true

module Crypto
  module Services
    module NotificationEngine
      class << self
        def check(threshold)
          price = RedisClient.get('bitcoin_price')

          notify_user(threshold) if threshold.exceeds?(price.to_f)
        end

        def process(price)
          with_user_ids(price) { |ids| NotificationClient.notify(ids) }
        end

        private

        def notify_user(threshold)
          threshold.update_attribute(:notified_at, Time.now)
          NotificationClient.notify([threshold.user_id])
        end

        def with_user_ids(price)
          Threshold.uncached do
            query(price).in_batches do |batch|
              yield(batch.map(&:user_id))
              batch.update_all(notified_at: Time.now)
            end
          end
        end

        def query(price)
          # make use of notified_at column to notify users only once a day (avoid flooding)
          Threshold
            .select(:id, :user_id)
            .where('(notified_at IS NULL OR notified_at < ?) AND (lower > ? OR upper < ?)',
                   Time.now - 1.day, price, price)
        end
      end
    end
  end
end
