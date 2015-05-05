class AnalyseSentiments
  include Sidekiq::Worker

  def perform(url)
    discussion = Discussion.new(url)
    return unless discussion.get(:status) == 'in_creation'

    segmentiser = SentimentAnalyser::NGramSegmentizer.new(n: 2)

    posts = discussion.posts

    posts.map! do |post|
      text = post["raw_message"]
      post["sentiment"] = SentimentAnalyser.model.classify(segmentiser.segmentize(text))
      post
    end

    discussion.posts = posts
  end
end
