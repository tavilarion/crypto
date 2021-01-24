# frozen_string_literal: true

module Crypto
  module Entities
    class User < Grape::Entity
      expose :id, :email
    end
  end
end
