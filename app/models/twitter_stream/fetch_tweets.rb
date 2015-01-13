class TwitterStream::FetchTweets
  def self.perform(topic, tweets*)
    $twitter_rest.statuses(tweets).each do |tweet|
      TwitterStream::AddTweet.perform(topic, TwitterStream::SferiktwitterParsedTweet.new(tweet))
  end
end
