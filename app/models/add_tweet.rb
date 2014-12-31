class AddTweet
  def self.perform(topic, parsed_tweet)
    topic = Topic.find_by(title: topic) || Topic.create(title: topic)
    user = User.find_by(twitter_id: parsed_tweet.user_id) || User.create(twitter_id: parsed_tweet.user_id, name: parsed_tweet.user_name)
    tweet = Tweet.create(text: parsed_tweet.text, twitter_id: parsed_tweet.tweet_id, created_at: parsed_tweet.created_at.to_s)
    tweet.user = user                                            
    tweet.topic = topic
    tweet.save!
  end
end
