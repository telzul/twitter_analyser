class TwitterStream::AddTweet
  def self.perform(parsed_tweet)
    user = User.find_by(twitter_id: parsed_tweet.user_id) || User.create(twitter_id: parsed_tweet.user_id, name: parsed_tweet.user_name)
    tweet = Tweet.create(text: parsed_tweet.text, twitter_id: parsed_tweet.tweet_id, created_at: parsed_tweet.created_at.to_s)
    tweet.user = user

    # adding Topic
    topics = Topic.all
    topic = topics[topics.rindex {|t| t.included_in_text?(tweet.text)}] # TODO geht das nicht einfacher?
    tweet.topic = topic

    # adding referenced tweet
    unless parsed_tweet.reply_to.nil?
      referenced = TwitterStream::AddMissingTweet.add_missing_tweet(topic, tweet.reply_to)
      tweet.reply_to = referenced
    end
    
    tweet.save!
    tweet
  end
end
