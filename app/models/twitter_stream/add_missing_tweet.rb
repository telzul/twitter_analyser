class TwitterStream::AddMissingTweet
  def self.add_missing_tweet(topic, missing_id)
    topic = Topic.find_by(title: topic) || Topic.create(title: topic)
    tweet = Tweet.create(twitter_id: missing_id)
    tweet.topic = topic
    tweet.save!
  end

  def self.update_missing_details(parsed_tweet)
    tweet = Tweet.find_by(twitter_id: parsed_tweet.tweet_id)
    user = User.find_by(twitter_id: parsed_tweet.user_id) || User.create(twitter_id: parsed_tweet.user_id, name: parsed_tweet.user_name)
    tweet.text = parsed_tweet.text
    tweet.created_at = parsed_tweet.created_at.to_s
    tweet.user = user                                   
    tweet.save!
  end
end
