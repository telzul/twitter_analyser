class AddTweet
  def self.perform(parsed_tweet)
    tweet = Tweet.create(text: parsed_tweet.text, twitter_id: parsed_tweet.tweet_id, created_at: parsed_tweet.created_at.to_s)
    user = User.find_by(twitter_id: parsed_tweet.user_id) || User.create(twitter_id: parsed_tweet.user_id, name: parsed_tweet.user_name)
    tweet.user = user
    tweet.save!
  end
end
