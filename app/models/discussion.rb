class Discussion

  attr_reader :url

  def initialize(url)
    @url = url
  end

  def self.exists?(url)
    Sidekiq.redis do |conn|
      conn.exists? url
    end
  end

  def status
    Sidekiq.redis do |conn|
      conn.get "#{url}:status"
    end
  end


end