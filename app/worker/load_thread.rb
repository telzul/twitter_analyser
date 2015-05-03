class LoadThread
  include Sidekiq::Worker

  def perform(url)
    discussion = Discussion.new(url)
    posts = DisqusApi.v3.posts.list("forum" => discussion.forum_name, "thread:ident" => discussion.thread_ident).all
    discussion.posts = posts
  end
end
