class ParseThreadId
  include Sidekiq::Worker
  include Open4
  def perform(url)
    output = ''
    script_path = File.join(Rails.root,"lib","get_disqus_forum_name.js")
    cmd = "phantomjs #{script_path} #{url}"
    spawn cmd, 'stdout' => output, 'timeout' => 90
    output.chomp!
    result = output.split("\n")
    discussion = Discussion.new(url)
    discussion.set("forum_name", result[0])
    discussion.set("thread_ident", result[1])
  end

end
