class SferiktwitterParsedTweet
  # we could also replace this by a simple struct
  attr_reader :text, :tweet_id, :user_name, :user_id, :created_at
  
  def initialize(tweet)
    @text = tweet.text
    @tweet_id = tweet.id
    @user_name = tweet.user.name
    @user_id = tweet.user.id
    @created_at = tweet.created_at
  end
end
