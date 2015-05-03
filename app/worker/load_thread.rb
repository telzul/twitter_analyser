class LoadThread
  include Sidekiq::Worker

  def perform(url)
    discussion = Discussion.new(url)
    posts = DisqusApi.v3.threads.listPosts(
        "forum" => discussion.get("forum_name"),
        "thread:ident" => discussion.get("thread_ident")
    ).all
    discussion.posts = posts
  end
end
