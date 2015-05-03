class ParseThreadId
  include Sidekiq::Worker
  include Open4
  def perform(url)
    output = ''
    script_path = File.join(Rails.root,"lib","get_disqus_forum_name.js")
    cmd = "phantomjs #{script_path} #{url}"
    spawn cmd, 'stdout' => output, 'timeout' => 90
    output.chomp!
    discussion = Discussion.new(url)
    discussion.set("thread_id", output)
  end

end
