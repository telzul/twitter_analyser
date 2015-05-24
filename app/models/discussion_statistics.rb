class DiscussionStatistics
  COLORS = {
    'positive' => '#7fb800',
    'negative' => '#f6511d',
    nil => '#bbb'
  }

  CLEAN_SENTIMENTS = {
    'positive' => 'positive',
    'negative' => 'negative',
    nil => 'nothing'
  }

  def initialize(discussion)
    @discussion = discussion
  end

  def tree_data_old
    @discussion.posts.map do |post|
      post['parent'] = @discussion.url if post['parent'].nil?
      post[:color] = COLORS[post[:sentiment]]
    end. << ({ 'id' => @discussion.url, 'parent' => nil })
  end

  def tree_data
    @root = [{ 'parent' => nil, 'name' => @discussion.url }]
    @data = @discussion.posts.map do |t|
      { sentiment: t['sentiment'],
        parent: t['parent'].nil? ? @discussion.url : t['parent'],
        name: t['id'],
        color: COLORS[t['sentiment']],
        text: t['raw_message']
      }
    end
    @data.inject(@root, :<<)
  end

  def user_sentiments
    data = Hash.new { |hash, key| hash[key] = { 'username' => key, 'positive' => 0, 'negative' => 0, 'nothing' => 0 } }
    @discussion.posts.reduce(data) do |mem, post|
      mem[post['author']['username']][CLEAN_SENTIMENTS[post['sentiment']]] += 1
      mem
    end
    # result = []
    data.values.sort { |b, a| (a['positive'] + a['negative'] + a['nothing']) <=> (b['positive'] + b['negative'] + b['nothing']) }
    # .each do |entry|
    #   result << {"username" => entry["username"], "sentiment" => "positive", "count" => entry["positive"]}
    #   result << {"username" => entry["username"], "sentiment" => "negative", "count" => entry["negative"]}
    #   result << {"username" => entry["username"], "sentiment" => "nothing", "count" => entry["nothing"]}
    # end
    # result
  end

  def sunburst_data
    root = { username: 'root', children: [] }
    entries = Hash.new do |hash, key|
      hash[key['id']] = {
        username: key['author']['username'],
        sentiment: key['sentiment'],
        children: [],
        parent: key['parent'],
        color: COLORS[key['sentiment']] }
    end
    result = @discussion.posts.reduce(entries) do |mem, post|
      mem[post]
      mem
    end
    result.each do |_key, entry|
      if !entry[:parent]
        root[:children] << entry
      elsif result.key? entry[:parent].to_s
        result[entry[:parent].to_s][:children] << entry
      else
        puts entry
      end
    end
    result.each do |_key, entry|
      entry[:size] = 1 if entry[:children].empty?
    end
    root
  end

  def sentiment_data
    data = Hash.new(0)
    @discussion.posts.map do |post|
      if post['sentiment'] == 'positive'
        data['positive'] += 1
      elsif post['sentiment'] == 'negative'
        data['negative'] += 1
      else
        data['nothing'] += 1
      end
    end
    data.map { |k, v| { 'sentiment' => k, 'value' => v } }
  end
end
