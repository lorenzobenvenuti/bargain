class UpdatePriceTask
  def perform
    Item.all.each do |item|
      begin
        Crono.logger.info("Retrieving price for #{item.name}")
        service = ScraperService.for_host(URI(item.url).host)
        price = service.get_price(item.url)
        Crono.logger.info("Price = #{price}")
        PriceHistoryService.new.update_price(item, price)
      rescue StandardError => e
        Crono.logger.error("Error #{e.message} occurred while updating price of #{item.name}")
        Crono.logger.error("Backtrace: #{e.backtrace}")
      end
    end
  end
end
