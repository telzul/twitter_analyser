class LoadThread
  include Sidekiq::Worker

  def perform(url)
    discussion = Discussion.new(url)
    posts = DisqusApi.v3.threads.listPosts(
        "thread" => discussion.get("thread_id")
    ).all
    discussion.posts = posts
  end
end
