# frozen_string_literal: true

module Crypto
  class Core < Grape::API
    prefix :api
    format :json

    # load helpers
    helpers Crypto::Support::Errors
    helpers Crypto::Support::Auth

    # mount all API endpoints
    mount Auth

    namespace do
      before { verify_token }

      mount Thresholds
      mount Price
    end

    desc 'Get current status/version'
    get :status do
      { status: :ok, version: API_VERSION }
    end

    # swagger docs
    SWAGGER_INFO = {
      title: 'Cryptocurrency price notifier',
      description: 'API for bitcoin price notifications'
    }.freeze

    add_swagger_documentation api_version: API_VERSION,
                              info: SWAGGER_INFO,
                              schemes: 'http'
  end
end
