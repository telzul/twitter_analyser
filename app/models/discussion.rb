class Discussion
  attr_reader :url

  def self.create(url)
    return false if exists?(url)

    Sidekiq.redis do |conn|
      conn.multi do
        conn.set url, Time.now.to_i, ex: expiry
        conn.set "#{url}:status", 'in_creation', ex: expiry
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

  def set(attribute, value)
    key = "#{url}:#{attribute}"
    Sidekiq.redis do |conn|
      if value.is_a? Hash
        conn.mapped_hmset key, value
        conn.expire key, self.class.expiry
      else
        conn.set key, value, ex: self.class.expiry
      end
    end
  end

  def get(attribute)
    key = "#{url}:#{attribute}"
    Sidekiq.redis do |conn|
      type = conn.type key

      if type == 'string'
        conn.get key
      elsif type == 'hash'
        conn.hgetall key
      end
    end
  end

  def posts=(posts)
    set(:posts, posts.to_json)
  end

  def posts
    JSON.parse(get(:posts)) rescue nil
  end

  def details=(details)
    set(:details, details.to_json)
  end

  def details
    JSON.parse(get(:details)) rescue nil
  end
end
