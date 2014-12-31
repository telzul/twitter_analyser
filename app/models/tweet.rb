class Tweet
  include Neo4j::ActiveNode
  property :text
  property :twitter_id
  property :created_at
  has_one :in, :user, origin: :tweets, model_class: User
  has_one :in, :topic, model_class: Topic
end
