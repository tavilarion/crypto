# frozen_string_literal: true

module Crypto
  module Services
    module RedisClient
      class << self
        def get(key)
          redis.get(key)
        end

        def set(key, value)
          redis.set(key, value)
        end

        private

        def redis
          @redis ||= Redis.new(url: Crypto.config[:redis_url])
        end
      end
    end
  end
end
