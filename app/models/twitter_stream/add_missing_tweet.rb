class TwitterStream::AddMissingTweet
  def self.add_missing_tweet(topic, missing_id)
    tweet = Tweet.create(twitter_id: missing_id)
    tweet.topic = topic
    tweet.save!
  end

  def self.update_missing_details(parsed_tweet)
    tweet = Tweet.find_by(twitter_id: parsed_tweet.tweet_id)
    user = User.find_by(twitter_id: parsed_tweet.user_id) || User.create(twitter_id: parsed_tweet.user_id, name: parsed_tweet.user_name)
    tweet.user = user                                   
    tweet.text = parsed_tweet.text
    tweet.created_at = parsed_tweet.created_at.to_s
    
    # adding referenced tweet
    unless parsed_tweet.reply_to.nil?
      referenced = TwitterStream::AddMissingTweet.add_missing_tweet(topic, tweet.reply_to)
      tweet.reply_to = referenced
    end
    tweet.save!
  end
end
