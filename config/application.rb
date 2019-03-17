require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Bargain
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    config.logger = Logger.new(STDOUT)


    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      address:              ENV['SMTP_HOST'] || 'localhost',
      port:                 ENV['SMTP_PORT'] || 25
    }

    config.x.web_page_renderer.type = 'rendertron'
    config.x.web_page_renderer.rendertron_url = ENV['RENDERTRON_URL'] || 'http://localhost:8080'

    config.x.elasticsearch_url = ENV['ELASTICSEARCH_URL'] || 'http://localhost:9200'
    config.x.elasticsearch_index = ENV['ELASTICSEARCH_INDEX'] || 'prices-%Y%m'
    config.x.elasticsearch_doc_type = ENV['ELASTICSEARCH_DOCTYPE'] || 'price'
  end
end
