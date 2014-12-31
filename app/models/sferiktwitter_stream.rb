class SferiktwitterStream
  # wrapper, becaus the gem says the streaming function is unstable, we might need to change
  def self.stream(topic)
    $twitter_stream.filter(track: topic) { |tweet| yield SferiktwitterParsedTweet.new(tweet) }
  end
end
