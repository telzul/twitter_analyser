class Tweet
  include Neo4j::ActiveNode
  property :text
  property :twitter_id
  property :created_at
  has_one :in, :user, origin: :tweets, model_class: User
end
