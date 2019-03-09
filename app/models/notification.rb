class Notification < ApplicationRecord
  belongs_to :item

  validates_presence_of :notification_type, :notification_args
  validates :threshold, numericality: { greater_than: 0 }
  validates :notification_type, inclusion: { in: %w(email) }

  def price_went_above_threshold?(curr_price, prev_price)
    !prev_price.nil? && prev_price <= threshold && curr_price > threshold
  end

  def price_is_below_threshold?(curr_price, prev_price)
    curr_price <= threshold && (prev_price.nil? || prev_price != curr_price)
  end
end
