require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GppHyrax
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Enable email notifications
    config.action_mailer.perform_deliveries = true
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
        address: ENV["SMTP_ADDRESS"],
        port: ENV["SMTP_PORT"],
        enable_starttls_auto: false
    }
    config.action_mailer.default_url_options = { host: ENV["ACTION_MAILER_HOST"] }
  end
end
