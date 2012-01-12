require 'redis/namespace'

redis_config = {}

if ENV["REDISTOGO_URL"]
  uri = URI.parse(ENV["REDISTOGO_URL"])
  redis_config = { :host => uri.host, :port => uri.port, :password => uri.password }
end

redis = Redis.new(redis_config)
$redis = Redis::Namespace.new(:hubot_catalog, :redis => redis)
