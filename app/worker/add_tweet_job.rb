class AddTweetJob
  include Sidekiq::Worker

  def perform(tweet_data)
    twitter_tweet = Twitter::Tweet.new(JSON.parse(tweet_data, :symbolize_names => true))

    tweet = Tweet.from_twitter_tweet(twitter_tweet)

    unless twitter_tweet.in_reply_to_status_id.nil?
      AddReferencedTweetJob.perform_async(twitter_tweet.in_reply_to_status_id, twitter_tweet.id)
    end
  end
end