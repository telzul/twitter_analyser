class SentimentTaggingJob

  include Sidekiq::Worker

  def perform(twitter_id)
    tweet = Tweet.find_by(:twitter_id => twitter_id)
    tweet.sentiment = SentimentAnalyser.classify(tweet.text)

    tweet.save
  end
end