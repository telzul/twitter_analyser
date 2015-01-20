class Tweet
  include Neo4j::ActiveNode
  property :text
  property :twitter_id
  property :created_at
  property :sentiment
  has_one :in, :user, origin: :tweets, model_class: User
  has_many :in, :topics, model_class: Topic
  has_many :in, :replies, model_class: Tweet, origin: :reply_to
  has_one :out, :reply_to, model_class: Tweet

  after_create :analyse_sentiment

  def self.from_twitter_tweet(twitter_tweet)
    tweet = self.create(
        text: twitter_tweet.text,
        twitter_id: twitter_tweet.id,
        created_at: twitter_tweet.created_at.to_s
    )

    # user
    user = User.find_by(twitter_id: twitter_tweet.user.id) || User.create(twitter_id: twitter_tweet.user.id, name: twitter_tweet.user.screen_name)
    tweet.user = user

    # adding Topic
    tweet.topics = Topic.all.select {|topic| twitter_tweet.text.include?(topic.title)}

    tweet
  end

  def to_json
    { text: self.text, twitter_id: self.twitter_id, created_at: self.created_at, user: self.user.id, reply_to: self.reply_to.id }.to_json
  end

  def analyse_sentiment
    SentimentTaggingJob.perform_async(twitter_id)
  end
end
