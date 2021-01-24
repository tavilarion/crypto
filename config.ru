# frozen_string_literal: true

require 'rack/cors'
require_relative 'config/boot'

use OTR::ActiveRecord::ConnectionManagement

use Rack::Cors do
  allowed_headers = %i[get post put patch delete]
  allow do
    origins '*'
    resource '*', headers: :any, methods: allowed_headers
  end
end

run Crypto::Core
