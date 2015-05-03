class DiscussionStatistics
  COLORS = {
      "positive" => "green",
      "negative" => "red",
      nil => "blue"
  }

  def initialize(discussion)
    @discussion = discussion
  end

  def tree_data
    @discussion.posts.map do |post|
      if post[:parent] == nil
        post[:parent]=@discussion.url
      end

      post[:color] = COLORS[post[:sentiment]]
      post
    end. << ({"id"=>@discussion.url, "parent" => nil })
  end

  def sentiment_data
    data=Hash.new(0)
    @discussion.posts.map do |post|
      if post[:sentiment] == 'positive'
        data[:positive]+=1
      elsif post[:sentiment] =='negative'
        data[:negative] += 1
      else
        data[:nothing] +=1
      end
    end
    data
  end

end