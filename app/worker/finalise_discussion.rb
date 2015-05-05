class FinaliseDiscussion
  include Sidekiq::Worker

  def perform(url)
    discussion= Discussion.new(url)
    discussion.set(:status,"created") unless discussion.get(:status) == 'in_creation'
  end
end