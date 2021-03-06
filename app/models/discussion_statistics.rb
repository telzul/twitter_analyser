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

  # returns the tree of the disqus thread as a list of entries with id references to their parents. nodes are identified by their field 'name'. The root has the discussions url as name.
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

  # outputs the 75 users with the most overall comments, sorted
  # in the form:
  # [{username: "name", positive: 2, negative: 4, nothing: 1}, …]
  def user_sentiments
    data = Hash.new { |hash, key| hash[key] = { 'username' => key, 'positive' => 0, 'negative' => 0, 'nothing' => 0 } }
    @discussion.posts.reduce(data) do |mem, post|
      mem[post['author']['username']][CLEAN_SENTIMENTS[post['sentiment']]] += 1
      mem
    end
    data.values.sort { |b, a| (a['positive'] + a['negative'] + a['nothing']) <=> (b['positive'] + b['negative'] + b['nothing']) }
      .select { |user| (user['positive'] + user['negative'] + user['nothing']) > 1 }[0..75]
  end

  # returns a tree in the form:
  # { username: 'root', children: [ #root node
  #   { username: '...', text: '...', sentiment: '...', parent: id, children: [...]}, # inner node
  #   { username: '...', text: '...', sentiment: '...', parent: id, size: 3 }  # leaf node
  # ] }
  def sunburst_data
    root = { username: 'root', children: [] }
    entries = Hash.new do |hash, key|
      hash[key['id']] = {
        username: key['author']['username'],
        sentiment: CLEAN_SENTIMENTS[key['sentiment']],
        children: [],
        parent: key['parent'],
        text: key['raw_message'] }
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
      end
    end
    result.each do |_key, entry|
      count = count_parents(entry, result)
      if entry[:children].empty? && entry[:parent].nil?
        root[:children].delete entry
      end
      entry[:size] = count if entry[:children].empty?
      # entry[:size] = 1 if entry[:children].empty?
    end
    root
  end

  def count_parents(entry, tree)
    count = 1
    current = entry
    loop do
      break if !current[:parent] || !tree.key?(current[:parent].to_s)
      current = tree[current[:parent].to_s]
      count += 1
    end
    count
  end

  # counts the sentiments present in the data and returns it as:
  # [{"sentiment"=>"positive", "value"=>73}, {"sentiment"=>"nothing", "value"=>76}, {"sentiment"=>"negative", "value"=>129}] 
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
