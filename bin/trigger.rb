#!/usr/bin/env ruby

#
# For testing in development only
# Similar code should be in a lambda function on AWS which runs periodically
#

require_relative '../config/boot'

# for testing simplicity, initialize database
`bundle exec rake db:create db:schema:load`

to_sleep = 5

while(true) do
  # due to nr of requests limit (100 per second)
  # compare our price stored in redis with the price from the api every to_sleep seconds
  # (in production this value can be lowered)
  sleep(to_sleep)

  current_price = Crypto::Services::RedisClient.get('bitcoin_price').to_f || 0

  Crypto.logger.info('Fetching bitcoin price...')
  new_price = Crypto::Services::CoinApiClient.fetch_bitcoin_price
  Crypto.logger.info("New price: #{new_price}  Saved price: #{current_price}")


  next if current_price == new_price

  Crypto.logger.info('Price updated. Triggering notification engine...')

  # if price differs, update and trigger the notification engine
  # Note: triggering here directly for simplicity, should be an API call or pushing in a message queue
  # to be handled by a different process
  Crypto::Services::RedisClient.set('bitcoin_price', new_price)

  Crypto::Services::NotificationEngine.process(new_price)
end
