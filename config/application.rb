require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GppHyrax
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    config.autoload_paths += %W(#{config.root}/lib)

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Enable email notifications
    config.action_mailer.perform_deliveries = true
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      address: ENV['SMTP_ADDRESS'],
      port: ENV['SMTP_PORT'],
      user_name: ENV['SMTP_USER_NAME'],
      password: ENV['SMTP_PASSWORD'],
      enable_starttls_auto: ENV['ENABLE_STARTTLS_AUTO']
    }
    config.action_mailer.default_url_options = { host: ENV['RAILS_HOST'] }

    config.calendar = Business::Calendar.new(
      working_days: %w( mon tue wed thu fri ),
      holidays: ['2020-01-01', '2020-01-20', '2020-02-17', '2020-05-25', '2020-07-04', '2020-07-03', '2020-09-07', '2020-10-12', '2020-11-03', '2020-11-11', '2020-11-26', '2020-12-25', '2021-01-01', '2021-12-31', '2021-01-18', '2021-02-15', '2021-05-31', '2021-07-04', '2021-07-05', '2021-09-06', '2021-10-11', '2021-11-02', '2021-11-11', '2021-11-25', '2021-12-25', '2021-12-24', '2022-01-01', '2022-01-17', '2022-02-21', '2022-05-30', '2022-07-04', '2022-09-05', '2022-10-10', '2022-11-08', '2022-11-11', '2022-11-24', '2022-12-25', '2022-12-26', '2023-01-01', '2023-01-02', '2023-01-16', '2023-02-20', '2023-05-29', '2023-07-04', '2023-09-04', '2023-10-09', '2023-11-07', '2023-11-11', '2023-11-10', '2023-11-23', '2023-12-25', '2024-01-01', '2024-01-15', '2024-02-19', '2024-05-27', '2024-07-04', '2024-09-02', '2024-10-14', '2024-11-05', '2024-11-11','2024-11-28', '2024-12-25']
    )

    config.local_timezone = ENV['LOCAL_TIMEZONE']
  end
end

Rails.application.routes.default_url_options[:host] = ENV['RAILS_HOST']
