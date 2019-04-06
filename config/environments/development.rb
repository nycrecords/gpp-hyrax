Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
        'Cache-Control' => "public, max-age=#{2.days.seconds.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  # SAML Settings
  idp_metadata_parser = OneLogin::RubySaml::IdpMetadataParser.new
  idp_metadata = idp_metadata_parser.parse_remote_to_hash(ENV['IDP_METADATA_URL'])
  sp_cert = Rails.root.join('config', 'certs', 'sp.crt')
  sp_key = Rails.root.join( 'config', 'certs', 'sp.key')
  config.saml_setttings = {
      issuer: "https://gpp-hyrax-dev-joel.appdev.records.nycnet/users/auth/saml/metadata",
      idp_sso_target_url: idp_metadata[:idp_sso_target_url],
      idp_slo_target_url: idp_metadata[:idp_slo_target_url],
      assertion_consumer_service_binding: "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST",
      assertion_consumer_service_url: "https://gpp-hyrax-dev-joel.appdev.records.nycnet/users/auth/saml/callback",
      name_identifier_format: "urn:oasis:names:tc:SAML:2.0:nameid-format:persistent",
      request_attributes: {},
      idp_cert: idp_metadata[:idp_cert],
      certificate: File.read(sp_cert),
      private_key: File.read(sp_key),
      security: {
          authn_requests_signed: true,
          logout_requests_signed: true,
          logout_responses_signed: true,
          want_assertions_signed: true,
          want_assertions_encrypted: false,
          want_messages_signed: false,
          metadata_signed: false,
          signature_method: XMLSecurity::Document::RSA_SHA1,
          digest_method: XMLSecurity::Document::SHA1
      }
  }
end
