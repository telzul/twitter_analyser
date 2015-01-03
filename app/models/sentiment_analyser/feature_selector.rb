class SentimentAnalyser::FeatureSelector


  def initialize(corpus)
    @corpus = corpus
    @label_fd = {}
    @label_ngram_fd = {}
  end


  def significant_ngrams(n=200)
    ngrams_sorted.first(n)
  end

  def ngrams_sorted
    @ngrams_sorted ||= @corpus.data.values.flatten.uniq.sort_by {|ngram| -significance(ngram)}
  end

  def label_fd(label)
    @label_fd[label] ||= @corpus.documents(label).flatten.count
  end

  def label_ngram_fd(label,ngram)
    @label_ngram_fd[label] ||= @corpus.documents(label).flatten.inject(Hash.new(0)) {|hash,ng| hash[ng]+=1; hash}
    @label_ngram_fd[label][ngram]
  end

  def ngram_fd(ngram)
    @ngram_fd ||= @corpus.data.values.flatten.inject(Hash.new(0)) {|hash,ng| hash[ng]+=1; hash}
    @ngram_fd[ngram]
  end

  def total_ngram_count
    @total_ngram_count ||= @corpus.data.values.flatten.count
  end

  def significance(ngram)
    @corpus.labels.inject(0) do |sum,label|
        sum + SentimentAnalyser::BigramAssociationMeasures.new(
            label_ngram_fd(label,ngram),
            ngram_fd(ngram),
            label_fd(label),
            total_ngram_count
        ).chi_square
    end
  end
end