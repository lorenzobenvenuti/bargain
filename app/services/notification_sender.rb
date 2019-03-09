class NotificationSenderFactory
  def notification_sender(notification)
    case notification.notification_type
    when 'email'
      return EmailNotificationSender.new(notification)
    end
    raise "Unsupported notification type #{notification_type}"
  end
end

class EmailNotificationSender
  def initialize(notification)
    @notification = notification
  end

  def send_above_threshold(item)
    NotificationMailer.with(
      item: item, notification: @notification
    ).above_threshold_email.deliver_now
  end

  def send_below_threshold(item)
    NotificationMailer.with(
      item: item, notification: @notification
    ).below_threshold_email.deliver_now
  end
end

class NotificationSender
  def initialize(item, sender_factory = NotificationSenderFactory.new)
    @item = item
    @sender_factory = sender_factory
  end

  def handle_notification(notification, prev_price)
    sender = @sender_factory.notification_sender(notification)
    if notification.price_went_above_threshold?(@item.last_price, prev_price)
      sender.send_above_threshold(@item)
    elsif notification.price_is_below_threshold?(@item.last_price, prev_price)
      sender.send_below_threshold(@item)
    end
  end

  def check(prev_price)
    @item.notifications.each do |notification|
      handle_notification(notification, prev_price)
    end
  end
end
