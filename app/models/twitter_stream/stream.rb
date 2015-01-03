class TwitterStream::Stream
  
  def self.stream(topic)
    stream=TwitterStream::SferiktwitterStream
    stream.stream(topic) { |tweet| TwitterStream::AddTweet.perform(topic, tweet) }
  end
end
