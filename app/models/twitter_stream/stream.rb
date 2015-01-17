class TwitterStream::Stream
  
  def self.stream(topic)
    Topic.find_or_create_by(title: topic)
    self.sferik_stream(topic) do |tweet|
      TwitterStream::AddTweet.perform(tweet)
    end
  end

  private
  def self.sferik_stream(topic)
    $twitter_stream.filter(track: topic) do |tweet|
      yield TwitterStream::SferiktwitterParsedTweet.new(tweet)
    end
  end
end
