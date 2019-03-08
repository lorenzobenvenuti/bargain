# Price Tracker

A [CamelCamelCamel](https://www.camelcamelcamel.com) clone that can be configured to support any (?) website.
I wrote this application to experiment with Ruby on Rails and distributed systems.
The application is composed of different processes:

* The Rails server
* [Crono](https://github.com/plashchynski/crono/issues) handling background jobs
* [PostgreSQL](https://www.postgresql.org/) to store data
* [Rendertron](https://github.com/GoogleChrome/rendertron) rendering pages for scraping
* [Elasticsearch](https://www.elastic.co/products/elasticsearch) to store historic data (so you can visualize it using [Kibana](https://www.elastic.co/products/kibana))
* An SMTP server to send notifications when a price goes above or below a given threshold

## Configuration

The application can be configured using the following environment variables:

* `PRICE_TRACKER_DB_NAME`: name of the database
* `PRICE_TRACKER_DB_USER`: database user
* `PRICE_TRACKER_DB_PASSWORD`: database password
* `PRICE_TRACKER_DB_HOST`: database host (default `localhost`)
* `PRICE_TRACKER_DB_PORT`: database port (default `5432`)
* `RENDERTRON_URL`: URL of Rendertron (default: `http://localhost:8080`)
* `ELASTICSEARCH_URL`: URL of Elasticsearch (default: `http://localhost:9200`)
* `ELASTICSEARCH_INDEX`: Elasticsearch index (default `prices-%Y%m`). It supports `strftime` syntax to insert time-dependent values.
* `ELASTICSEARCH_DOCTYPE`: Elasticsearch document type (default `price`)
* `SMTP_HOST`: SMTP host (default `localhost`)
* `SMTP_PORT`: SMTP port (default `25`)

## APIs

## Docker

## TODO

* Spread scrapers on multiple queues to avoid throttling
* Use *Patron* or *Typhoeus* to increase *Elasticsearch* client performance
* Rotate Elasticsearch index (i.e.: accept a {year}, {month}, {day} parameters
  in index name)
* Implement notifications

# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
