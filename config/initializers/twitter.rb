def config_client(config)
  config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
  config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
  config.access_token = ENV['TWITTER_ACCESS_TOKEN']
  config.access_token_secret = ENV['TWITTER_ACCESS_SECRET']
end

$twitter_rest = Twitter::REST::Client.new do |config|
  config_client(config)
end

$twitter_stream = Twitter::Streaming::Client.new do |config|
  config_client(config)
end
