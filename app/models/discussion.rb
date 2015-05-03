class Discussion

  attr_reader :url

  def self.create(url)
    return false if exists?(url)

    Sidekiq.redis do |conn|
      multi do
        conn.set url, Time.now.to_i, :ex => 1.weak.from_now.to_i
        conn.set "#{url}:status", "in_creation", :ex => 1.weak.from_now.to_i
      end

      #TODO Enqueue Job

      return true
    end
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
end