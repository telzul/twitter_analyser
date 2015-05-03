class Discussion

  attr_reader :url

  def self.create(url)
    return false if exists?(url)

    Sidekiq.redis do |conn|
      conn.multi do
        conn.set url, Time.now.to_i, :ex => expiry
        conn.set "#{url}:status", "in_creation", :ex => expiry
      end

      DiscussionPipeline.perform_async(url)

      return true
    end
  end

  def self.expiry
    1.week.from_now.to_i
  end

  def self.exists?(url)
    Sidekiq.redis do |conn|
      conn.exists url
    end
  end

  def initialize(url)
    @url = url
  end

  def set(attribute,value)
    Sidekiq.redis do |conn|
      conn.set "#{url}:#{attribute}", value, :ex => self.class.expiry
    end
  end

  def get(attribute)
    Sidekiq.redis do |conn|
      conn.get "#{url}:#{attribute}"
    end
  end

  def posts=(posts)
    set(:posts,posts.to_json)
  end

  def posts
      JSON.parse(get(:posts)) rescue nil
  end
end