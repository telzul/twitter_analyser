class DiscussionStatistics
  COLORS = {
      "positive" => "green",
      "negative" => "red",
      nil => "blue"
  }

  def initialize(discussion)
    @discussion = discussion
  end

  def tree_data_old
    @discussion.posts.map do |post|
      if post["parent"] == nil
        post["parent"]=@discussion.url
      end
      post[:color] = COLORS[post[:sentiment]]
    end. << ({"id"=>@discussion.url, "parent" => nil })
  end

  def tree_data
    @root=  [{"parent" => nil, "name" => @discussion.url}]
    @data=  @discussion.posts.map { |t| {sentiment: t["sentiment"],parent: t["parent"]==nil ? @discussion.url : t["parent"]  ,name: t["id"],color:COLORS[t["sentiment"]],text:t["raw_message"]}}
    @data.inject(@root,:<<) 
  end

  def sentiment_data
    data=Hash.new(0)
    @discussion.posts.map do |post|
      if post["sentiment"] == 'positive'
        data["positive"] +=1
      elsif post["sentiment"] =='negative'
        data["negative"] += 1
      else
        data["nothing"] +=1
      end
    end
    data.map {|k,v| {"sentiment" => k, "value" => v}}
  end

end
