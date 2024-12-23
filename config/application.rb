require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GppHyrax
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.eager_load_paths << Rails.root.join('lib')

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
      holidays: ['2020-01-01', '2020-01-20', '2020-02-17', '2020-05-25', '2020-07-04', '2020-07-03', '2020-09-07', '2020-10-12', '2020-11-03', '2020-11-11', '2020-11-26', '2020-12-25', '2021-01-01', '2021-12-31', '2021-01-18', '2021-02-15', '2021-05-31', '2021-07-04', '2021-07-05', '2021-09-06', '2021-10-11', '2021-11-02', '2021-11-11', '2021-11-25', '2021-12-25', '2021-12-24', '2022-01-01', '2022-01-17', '2022-02-21', '2022-05-30', '2022-07-04', '2022-09-05', '2022-10-10', '2022-11-08', '2022-11-11', '2022-11-24', '2022-12-25', '2022-12-26', '2023-01-01', '2023-01-02', '2023-01-16', '2023-02-20', '2023-05-29', '2023-07-04', '2023-09-04', '2023-10-09', '2023-11-07', '2023-11-11', '2023-11-10', '2023-11-23', '2023-12-25', '2024-01-01', '2024-01-15', '2024-02-19', '2024-05-27', '2024-07-04', '2024-09-02', '2024-10-14', '2024-11-05', '2024-11-11','2024-11-28', '2024-12-25', '2025-01-01', '2025-01-20', '2025-02-17', '2025-05-26', '2025-06-19', '2025-07-04', '2025-09-01', '2025-10-13', '2025-11-04', '2025-11-11', '2025-11-27', '2025-12-25', '2026-01-01', '2026-01-19', '2026-02-16', '2026-05-25', '2026-06-19', '2026-07-04', '2026-07-03', '2026-09-07', '2026-10-12', '2026-11-03', '2026-11-11', '2026-11-26', '2026-12-25', '2027-01-01', '2027-12-31', '2027-01-18', '2027-02-15', '2027-05-31', '2027-07-04', '2027-07-05', '2027-09-06', '2027-10-11', '2027-11-02', '2027-11-11', '2027-11-25', '2027-12-25', '2027-12-24', '2028-01-01', '2028-01-17', '2028-02-21', '2028-05-29', '2028-07-04', '2028-09-04', '2028-10-09', '2028-11-07', '2028-11-11', '2028-11-10', '2028-11-23', '2028-12-25', '2029-01-01', '2029-01-15', '2029-02-19', '2029-05-28', '2029-07-04', '2029-09-03', '2029-10-08', '2029-11-06', '2029-11-11', '2029-11-12', '2029-11-22', '2029-12-25', '2030-01-01', '2030-01-21', '2030-02-18', '2030-05-27', '2030-07-04', '2030-09-02', '2030-10-14', '2030-11-05', '2030-11-11', '2030-11-28', '2030-12-25']
    )

    config.local_timezone = ENV['LOCAL_TIMEZONE']

    config.i18n.default_locale = :en
    config.i18n.available_locales = [:en]

    config.active_job.queue_adapter = :sidekiq
  end
end

Rails.application.routes.default_url_options[:host] = ENV['RAILS_HOST']
