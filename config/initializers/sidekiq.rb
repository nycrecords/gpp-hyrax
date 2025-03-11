# frozen_string_literal: true

config = YAML.safe_load(ERB.new(IO.read(Rails.root + 'config' + 'redis.yml')).result)[Rails.env].with_indifferent_access
redis_config = config.merge(thread_safe: true)

Sidekiq.configure_server do |s|
  s.redis = redis_config
  Sidekiq::Status.configure_server_middleware s, expiration: 30.days
  Sidekiq::Status.configure_client_middleware s, expiration: 30.days
end

Sidekiq.configure_client do |s|
  s.redis = redis_config
  Sidekiq::Status.configure_client_middleware s, expiration: 30.days
end

Sidekiq.default_worker_options = { retry: 5 }