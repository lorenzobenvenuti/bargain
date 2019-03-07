class Item < ApplicationRecord
  has_many :notifications, dependent: :destroy

  validates_presence_of :name, :url

  def price_must_be_calculated?(now)
    return true if last_price_update.nil?
    (now - last_price_update) > (60 * interval)
  end
end
