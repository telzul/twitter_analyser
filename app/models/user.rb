class User
  include Neo4j::ActiveNode
  property :name
  property :twitter_id
  has_many :out, :tweets, type: :tweets, model_class: Tweet
end
