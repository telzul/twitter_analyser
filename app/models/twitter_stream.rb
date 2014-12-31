class TwitterStream
  
  def self.stream(topic)
    stream=SferiktwitterStream
    stream.stream(topic) { |tweet| AddTweet.perform(topic, tweet) }
  end
end
