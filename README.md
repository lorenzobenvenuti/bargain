# Bargain

A [CamelCamelCamel](https://www.camelcamelcamel.com)-like application  that can be configured to support any (?) website.
I wrote this application to play with distributed systems.
The application is composed of different processes:

* The Rails server
* [Crono](https://github.com/plashchynski/crono/issues) handling background jobs
* [PostgreSQL](https://www.postgresql.org/) to store data
* [Rendertron](https://github.com/GoogleChrome/rendertron) rendering pages for scraping
* [Elasticsearch](https://www.elastic.co/products/elasticsearch) to store historic data (so you can visualize it using [Kibana](https://www.elastic.co/products/kibana))
* An SMTP server to send notifications when a price goes above or below a given threshold

Right now the application is **not** designed to scale! The idea is to evolve the current design introducing multiple asynchronous background jobs that can handle scraping in a more efficient way.

## Configuration

The application can be configured using the following environment variables:

* `BARGAIN_DB_NAME`: name of the database
* `BARGAIN_DB_USER`: database user
* `BARGAIN_DB_PASSWORD`: database password
* `BARGAIN_DB_HOST`: database host (default `localhost`)
* `BARGAIN_DB_PORT`: database port (default `5432`)
* `RENDERTRON_URL`: URL of Rendertron (default: `http://localhost:8080`)
* `ELASTICSEARCH_URL`: URL of Elasticsearch (default: `http://localhost:9200`)
* `ELASTICSEARCH_INDEX`: Elasticsearch index (default `prices-%Y%m`). It supports `strftime` syntax to insert time-dependent values.
* `ELASTICSEARCH_DOCTYPE`: Elasticsearch document type (default `price`)
* `SMTP_HOST`: SMTP host (default `localhost`)
* `SMTP_PORT`: SMTP port (default `25`)

## APIs

APIs expose CRUD operations using standard HTTP verbs.

### Scrapers

Endpoint: `http://<host>:<port>/scrapers`

It supports standard CRUD operations plus an endpoint to test a scraper:

`http://<host>:<port>/scrapers/<id>/test?url=<item_url>`

Scraper structure:

```javascript
{
  "name": "Amazon",
  "hosts": [
    { "host": "www.amazon.it" },
    { "host": "www.amazon.com" }
  ],
  "rules": [
    { "rule_type": "css", "rule_args":"#priceblock_ourprice" },
    { "rule_type": "text" },
    { "rule_type": "sub", "rule_args": "/EUR\\s+([0-9,]+)/\\1/" },
    { "rule_type": "sub", "rule_args": "/,/./" }
  ]
}
```

* `hosts` are the hosts for which the scrapers applies.
* `rules` are the operations that must be applied to the resource retrieved from an URL in order to extract the price. Supported types are
  * `css`: retrieves a DOM node using a selector
  * `xpath`: retrieves a DOM node using XPath
  * `text`: extracts the node text
  * `attr`: extracts an attribute of the node
  * `sub`: substitutes a pattern

Sample request:

```bash
curl -X POST -H 'Content-type:application/json' -d @amazon.json  localhost:3000/scrapers
```

### Items

The items to watch.

Endpoint: `http://<host>:<port>/items`

It supports basic CRUD operations plus an endpoint to retrieve the item price:

`http://<host>:<port>/items/<id>/price`

Item structure:

```javascript
{
  "name": "Building Microservices",
  "url": "https://www.amazon.it/Building-Microservices-Designing-Fine-grained-Systems/dp/1492034029/ref=sr_1_2?ie=UTF8&qid=1552553769&sr=8-2&keywords=microservices",
  "interval": 30,
  "notifications": [
    { "notification_type": "email", "notification_args": "john.doe@example.com", "threshold": 30 }
  ]
}
```

`interval` is the interval in minutes between price checks.
`notifications` are the notifications to send when a price reaches the specified threshold.

Sample request:

```bash
curl -X POST -H 'Content-type:application/json' -d @amazon_item.json localhost:3000/items
```

## Docker

Perform database migrations:

```bash
docker run -it --rm -e RAILS_ENV=production -e BARGAIN_DB_NAME=<db-name> -e BARGAIN_DB_USER=<db-user> -e BARGAIN_DB_PASSWORD=<db-password> -e BARGAIN_DB_HOST=<db-host> -e BARGAIN_DB_PORT=<db-port> --entrypoint migrate.sh lorenzobenvenuti/bargain
```

Execute the application:

```bash
docker run -d --name bargain -p 3000:3000 -e RAILS_ENV=production -e BARGAIN_DB_NAME=<db-name> -e BARGAIN_DB_USER=<db-user> -e BARGAIN_DB_PASSWORD=<db-password> -e BARGAIN_DB_HOST=<db-host> -e BARGAIN_DB_PORT=<db-port> -e RENDERTRON_URL=<rendertron-url> -e ELASTICSEARCH_URL=<elasticsearch-url> -e SMTP_HOST=<smtp-host> lorenzobenvenuti/bargain
```

## TODO

* Introduce rules to retrieve and parse JSON
* Implement a queue system to allow the system to survive in case of a high item number.
* Application frontend
* Spread scrapers on multiple queues to avoid throttling
* Use *Patron* or *Typhoeus* to increase *Elasticsearch* client performance
  in index name)
