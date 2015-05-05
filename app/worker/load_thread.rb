class LoadThread
  include Sidekiq::Worker

  def perform(url)
    discussion = Discussion.new(url)
    return unless discussion.get(:status) == 'in_creation'

    id_data = discussion.get(:id)

    query = if id_data['thread_id']
              {'thread' => id_data['thread_id']}
            else
              {'forum' => id_data['forum_shortname'], 'thread:ident' => id_data['thread_ident']}
            end

    posts = DisqusApi.v3.threads.listPosts(query).all
    discussion.posts = posts
  end
end
