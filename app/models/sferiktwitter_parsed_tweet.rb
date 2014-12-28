class SferiktwitterParsedTweet

  attr_accessor :text, :tweet_id, :user_name, :user_id, :created_at
  
  def initialize(tweet)
    self.text = tweet.text
    self.tweet_id = tweet.id
    self.user_name = tweet.user.name
    self.user_id = tweet.user.id
    self.created_at = tweet.created_at
  end
end
