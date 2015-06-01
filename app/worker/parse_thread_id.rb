require 'tempfile'

class ParseThreadId
  include Sidekiq::Worker
  include Open4
  def perform(url)
    discussion = Discussion.new(url)

    tmpfile = Tempfile.new("disqus-id")
    begin

      script_path = File.join(Rails.root,"lib","get_disqus_forum_name.js")
      cmd = "phantomjs --ssl-protocol=any #{script_path} '#{url}' '#{tmpfile.path}'" #TODO: test if this works on 1.9 with the --ssl... option for https sites
      spawn cmd, timeout: 90

      data = JSON.parse(tmpfile.read) rescue nil

      if data && ((data["forum_shortname"] && data["thread_ident"]) || data["thread_id"])
        discussion.set("id", data)
      else
        discussion.set("status","id_extraction_failed")
      end

    ensure
      tmpfile.close!
    end
  end
end
