class AddReferencedTweetJob
  include Sidekiq::Worker

  def perform(tweet_id, reply_id)
    tweet=Tweet.find_by(:twitter_id => tweet_id)

    unless tweet
      twitter_tweet = $twitter_rest.status(tweet_id)
      tweet = Tweet.from_twitter_tweet(twitter_tweet)

      unless twitter_tweet.in_reply_to_status_id.nil?
        AddReferencedTweetJob.perform_async(twitter_tweet.in_reply_to_status_id, twitter_tweet.id)
      end
    end

    tweet.replies << Tweet.find_by(:twitter_id => reply_id)
    tweet.save
  end
end