# Redisの場所を特定するのにSidekiq.configure_serverブロックとSidekiq.configure_clientブロックの両方を定義する
Sidekiq.configure_server do |config|
  config.redis = {
    url: 'redis://localhost:6379'
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: 'redis://localhost:6379'
  }
end
