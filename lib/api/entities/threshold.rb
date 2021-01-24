# frozen_string_literal: true

module Crypto
  module Entities
    class Threshold < Grape::Entity
      expose :id, :user_id, :lower, :upper, :created_at, :updated_at
    end
  end
end
