class Notification < ApplicationRecord
  belongs_to :item

  validates_presence_of :notification_type, :notification_args
  validates :threshold, numericality: { greater_than: 0 }

  def price_went_above_threshold?(curr_price, prev_price)
    !prev_price.nil? && prev_price <= threshold && curr_price > threshold
  end

  def price_went_below_threshold?(curr_price, prev_price)
    (prev_price.nil? || prev_price > threshold) && curr_price <= threshold
  end
end
