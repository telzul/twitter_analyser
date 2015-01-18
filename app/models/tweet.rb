class Tweet
  include Neo4j::ActiveNode
  property :text
  property :twitter_id
  property :created_at
  property :sentiment
  has_one :in, :user, origin: :tweets, model_class: User
  has_one :in, :topic, model_class: Topic
  has_many :in, :replies, model_class: Tweet, origin: :reply_to
  has_one :out, :reply_to, model_class: Tweet

  def to_json
    { text: self.text, twitter_id: self.twitter_id, created_at: self.created_at, user: self.user.id, reply_to: self.reply_to.id }.to_json
  end
end
