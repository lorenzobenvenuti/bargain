class NotificationService
  def initialize(item)
    @item = item
  end

  def send_above_threshold_notification(notification)
    Rails.logger.info("Send above threshold notification")
    NotificationMailer.with(
      item: @item, notification: notification
    ).above_threshold_email.deliver_now
  end

  def send_below_threshold_notification(notification)
    Rails.logger.info("Send below threshold notification")
    NotificationMailer.with(
      item: @item, notification: notification
    ).below_threshold_email.deliver_now
  end

  def handle_notification(notification, prev_price)
    if notification.price_went_above_threshold?(@item.last_price, prev_price)
      send_above_threshold_notification(notification)
    elsif notification.price_is_below_threshold?(@item.last_price, prev_price)
      send_below_threshold_notification(notification)
    end
  end

  def check(prev_price)
    @item.notifications.each do |notification|
      handle_notification(notification, prev_price)
    end
  end
end
