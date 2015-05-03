class AnalyseSentiments
  include Sidekiq::Worker

  def perform(url)
    discussion = Discussion.new(url)
    segmentiser = SentimentAnalyser::NGramSegmentizer.new(n: 2)

    posts = discussion.posts

    posts.map! do |post|
      text = post["raw_message"]
      post["sentiment"] = SentimentAnalyser.model.classify(segmentiser.segmentize(text))
    end

    discussion.set(:posts,posts)
  end
end
