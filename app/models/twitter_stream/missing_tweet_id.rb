class TwitterStream::MissingTweetId
  include Neo4j::ActiveNode
  property :twitter_id
  property :topic
end
