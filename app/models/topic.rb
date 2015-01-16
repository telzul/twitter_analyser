class Topic
  include Neo4j::ActiveNode
  property :title
  has_many :out, :tweets, model_class: Tweet
  before_save :ensure_max_topics
  validates :title, length: {minimum: 1, maximum: 60}

  def included_in_text?(text)
    text.include?(title)
  end
  
  private
  def ensure_max_topics
    if Topic.count >= 400
      Topic.first.destroy
    end
  end
end
