class TwitterStream::FetchMissingTweets

  def self.perform()    
    tweet_ids = Tweet.where(text: nil).map(&:twitter_id).first(100)
    $twitter_rest.statuses(tweet_ids).each do |tweet|
      parsed_tweet = TwitterStream::SferiktwitterParsedTweet.new(tweet)
      TwitterStream::AddMissingTweet.update_missing_details(parsed_tweet)
    end
  end

end
