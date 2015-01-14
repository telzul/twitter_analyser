class TwitterStream::Stream
  
  def self.stream(topic)
    self.sferik_stream(topic) do |tweet|
      saved_tweet = TwitterStream::AddTweet.perform(topic, tweet)
      unless tweet.reply_to.nil?
        missing = TwitterStream::AddMissingTweet.add_missing_tweet(topic, tweet.reply_to)
        saved_tweet.reply_to = missing
        saved_tweet.save!
      end
    end
  end

  private
  def self.sferik_stream(topic)
    $twitter_stream.filter(track: topic) do |tweet|
      yield TwitterStream::SferiktwitterParsedTweet.new(tweet)
    end
  end
end
