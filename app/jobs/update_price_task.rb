class UpdatePriceTask
  def send_above_threshold_notification(notification, curr_price)
    Crono.logger("Send above threshold notification")
  end

  def send_below_threshold_notification(notification, curr_price)
    Crono.logger("Send below threshold notification")
  end

  def handle_notification(notification, curr_price, prev_price)
    if notification.price_went_above_threshold?(curr_price, prev_price)
      send_above_threshold_notification(notification, curr_price)
    elsif notification.price_went_below_threshold?(curr_price, prev_price)
      send_below_threshold_notification(notification, curr_price)
    end
  end

  def handle_notifications(item, prev_price)
    item.notifications.each do |notification|
      handle_notification(notification, item.last_price, prev_price)
    end
  end

  def update_price(item)
    Crono.logger.info("Retrieving price for #{item.name}")
    service = ScraperService.for_host(URI(item.url).host)
    price = service.get_price(item.url)
    Crono.logger.info("Updating item price with #{price}")
    prev_price = item.last_price
    item.last_price = price
    item.last_price_update = Time.now
    item.save!
    handle_notifications(item, prev_price)
    Crono.logger.info("Storing historic data")
    PriceHistoryService.new.update_price(item, price)
  end

  def perform
    Item.all.each do |item|
      unless item.price_must_be_calculated?(Time.now)
        Crono.logger.info("#{item.name} was updated at #{item.last_price_update} - skipping")
        next
      end
      begin
        update_price(item)
      rescue StandardError => e
        Crono.logger.error("Error #{e.message} occurred while updating price of #{item.name}")
        Crono.logger.error("Backtrace: #{e.backtrace}")
      end
    end
  end
end
