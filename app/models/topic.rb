class Topic
  include Neo4j::ActiveNode
  property :title
  has_many :out, :tweets, model_class: Tweet
end
