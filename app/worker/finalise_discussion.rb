class FinaliseDiscussion
  include Sidekiq::Worker

  def perform(url)
    Discussion.new(url).set(:status,"created")
  end
end