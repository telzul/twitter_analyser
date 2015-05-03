class Discussion

  attr_reader :url

  def self.create(url)
    return false if exists?(url)

    Sidekiq.redis do |conn|
      multi do
        conn.set url, Time.now.to_i, :ex => expiry
        conn.set "#{url}:status", "in_creation", :ex => expiry
      end

      #TODO Enqueue Job

      return true
    end
  end

  def self.expiry
    1.week.from_now.to_i
  end

  def self.exists?(url)
    Sidekiq.redis do |conn|
      conn.exists? url
    end
  end

  def initialize(url)
    @url = url
  end

  def status
    Sidekiq.redis do |conn|
      conn.get "#{url}:status"
    end
  end

  def forum_name=(name)
    Sidekiq.redis do |conn|
      conn.set "#{url}:forum_name", "name", :ex => self.class.expiry
    end
  end

  def forum_name
    Sidekiq.redis do |conn|
      conn.get "#{url}:forum_name"
    end
  end

  def thread_ident=(ident)
    Sidekiq.redis do |conn|
      conn.set "#{url}:thread_ident", "ident", :ex => self.class.expiry
    end
  end

  def thread_ident
    Sidekiq.redis do |conn|
      conn.get "#{url}:thread_ident"
    end
  end

  def posts=(posts)
    Sidekiq.redis do |conn|
      conn.set "#{url}:posts", posts.to_json, :ex => self.class.expiry
    end
  end

  def posts
    Sidekiq.redis do |conn|
      JSON.parse(conn.get "#{url}:posts") rescue nil
    end
  end
end