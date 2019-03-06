class UpdatePriceTask
  def perform
    Item.all.each do |item|
      Crono.logger.info("Retrieving price for #{item.name}")
      service = ScraperService.for_host(URI(item.url).host)
      price = service.get_price(item.url)
      Crono.logger.info("Price = #{price}")
      PriceHistoryService.new.update_price(item, price)
    end
  end
end
