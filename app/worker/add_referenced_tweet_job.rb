class AddReferencedTweetJob
  include Sidekiq::Worker

  # tweet_id describes the tweet now being created
  # reply_id describes the tweet this one is a reply to
  def perform(tweet_id, reply_id)
    tweet=Tweet.find_by(:twitter_id => tweet_id.to_s)

    unless tweet
      twitter_tweet = $twitter_rest.status(tweet_id)
      tweet = Tweet.from_twitter_tweet(twitter_tweet)

      unless twitter_tweet.in_reply_to_status_id.nil?
        AddReferencedTweetJob.perform_async(twitter_tweet.in_reply_to_status_id, twitter_tweet.id)
      end
    end
    original_tweet = Tweet.find_by(:twitter_id => reply_id.to_s)
    tweet.replies << original_tweet
    tweet.topics.concat (original_tweet.topics)
    tweet.save
  end
end
