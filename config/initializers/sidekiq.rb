# frozen_string_literal: true

# redis_server = ENV['REDIS_SERVER'] '127.0.0.1' # redis服务器
# redis_port = ENV['REDIS_PORT']6379 # redis端口
# redis_db_num = 0 # redis 数据库序号
redis_namespace = 'sidekiq'

Sidekiq.configure_server do |config|
  config.redis = { url: "<%= Settings.redis.server_url %>", namespace: redis_namespace }
end

Sidekiq.configure_client do |config|
  config.redis = { url: "<%= Settings.redis.server_url %>", namespace: redis_namespace }
end




