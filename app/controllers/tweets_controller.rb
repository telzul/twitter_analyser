class TweetsController < ApplicationController

  def index
    @stats = {tweet_count: Tweet.count, user_count: User.count, topic_count: Topic.count}
  end

  def show
    @tweet = Tweet.find(params[:id])
  end
  
end
