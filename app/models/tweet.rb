class Tweet < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :topics
  has_many :replies, class_name: Tweet, foreign_key: "reply_to_id"
  belongs_to :reply_to, class_name: Tweet 

  after_create :analyse_sentiment

  def self.from_twitter_tweet(twitter_tweet)
    tweet = self.create(
        text: twitter_tweet.text,
        twitter_id: twitter_tweet.id.to_s,
        created_at: twitter_tweet.created_at.to_s
    )

    # user
    user = User.find_by(twitter_id: twitter_tweet.user.id.to_s) || User.create(twitter_id: twitter_tweet.user.id.to_s, name: twitter_tweet.user.screen_name)
    tweet.user = user

    # adding Topic
    tweet.topics = Topic.all.select {|topic| twitter_tweet.text.downcase.include?(topic.title.downcase)}

    tweet
  end

  def to_json
    { text: self.text, twitter_id: self.twitter_id, created_at: self.created_at, user: self.user.id, reply_to: self.reply_to.id }.to_json
  end

  def analyse_sentiment
    SentimentTaggingJob.perform_async(twitter_id)
  end
end
