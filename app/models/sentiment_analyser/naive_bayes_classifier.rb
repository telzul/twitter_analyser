class SentimentAnalyser::NaiveBayesClassifier

  attr_reader :features, :labels

  def initialize(labels,features)
    @labels = labels
    @features = features
    @label_document_count = Hash.new(1)
    @label_feature_count = Hash.new {|k,v| k[v]= Hash.new(1)}
  end

  def train(label,content)
    @label_document_count[label] += 1
    content.uniq.each do |c|
      if @features.include?(c)
        @label_feature_count[label][c] += 1
      end
    end
  end

  def test(label,content)
    document_count_other_labels = (@label_document_count.values.inject(:+) - @label_document_count[label]).to_f

    prior = Math.log(@label_document_count[label] / document_count_other_labels)

    likelihood = content.inject(0) do |sum,feature|
      a = @label_feature_count[label][feature] / @label_document_count[label].to_f
      b = ((@labels - [label]).inject(0) {|s,l| s + @label_feature_count[l][feature]}) / document_count_other_labels

      sum + Math.log(a/b)
    end

    prior + likelihood
  end

  def classify(content)
    data = content.
        uniq.
        reject {|ngram| !@features.include?(ngram)}

    @labels.find do |label|
      test(label,data) > 0.0
    end
  end
end