# frozen_string_literal: true

class Threshold < ActiveRecord::Base
  def exceeds?(price)
    price < lower || price > upper
  end
end
