# frozen_string_literal: true

module Crypto
  class Auth < ::Grape::API
    namespace :authentication do
      #
      # Registration - POST api/authentication/register
      #
      desc 'Register user'
      params do
        requires :email, type: String, documentation: { in: 'body' }
        requires :password, type: String, documentation: { in: 'body' }
        requires :password_confirmation, type: String, documentation: { in: 'body' }
      end

      post :register do
        validation_failed!('Password mismatch') if params[:password] != params[:password_confirmation]

        Crypto.logger.info("Registering user with email: #{params[:email]}")

        user = Services::Registration.register(email: params[:email], password: params[:password])

        present user, with: Entities::User
      end

      #
      # Authentication - POST api/authentication
      #
      desc 'Authenticate user'
      params do
        requires :email, type: String, documentation: { in: 'body' }
        requires :password, type: String, documentation: { in: 'body' }
      end

      post do
        Crypto.logger.info("Authenticating user with email: #{params[:email]}")

        token = Services::Authentication.new(email: params[:email], password: params[:password]).authenticate

        present token: token
      rescue Services::Errors::Unauthorized
        unauthorized!
      end
    end
  end
end
