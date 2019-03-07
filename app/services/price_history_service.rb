require 'elasticsearch'
require 'time'

class ElasticSearchBackend
  def initialize(url, index, type)
    @url = url
    @index = index
    @type = type
  end

  def store(doc)
    client = Elasticsearch::Client.new(url: @url, log: true)
    client.create(index: Time.now.strftime(@index), type: @type, body: doc)
  end
end

class BackendFactory
  def backend
    ElasticSearchBackend.new(
      Rails.configuration.x.elasticsearch_url,
      Rails.configuration.x.elasticsearch_index,
      Rails.configuration.x.elasticsearch_doc_type
    )
  end
end

class PriceHistoryService
  def initialize(backend_factory = BackendFactory.new)
    @backend_factory = backend_factory
  end

  def update_price(item, price)
    @backend_factory.backend.store(
      item_id: item.id,
      name: item.name,
      url: item.url,
      price: price,
      timestamp: Time.now.utc.iso8601
    )
  end
end
