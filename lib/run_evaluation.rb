def testing
  puts "loading data"
  corpus=SentimentAnalyser::LabeledCorpus.from_csv("/home/max/imdb_corpus/corpus.csv")
  train_data = {}
  test_data = {}

  puts "setting up corpora"
  corpus.labels.each do |label|
    docs = corpus.documents(label)
    docs.sort_by! { rand(10000000) }
    train_data[label] = docs[(0..docs.count*0.75)]
    test_data[label] = docs[(docs.count*0.75+1..-1)]
  end

  train_corpus = SentimentAnalyser::LabeledCorpus.new(train_data)
  test_corpus = SentimentAnalyser::LabeledCorpus.new(test_data)


  [3000,5000,10000].each do |feature_count|
    features = SentimentAnalyser::FeatureSelector.new(corpus).significant_ngrams(feature_count)
    model = SentimentAnalyser::NaiveBayesClassifier.new(corpus.labels,features)

    train_corpus.data.each_pair do |label,docs|
      docs.each do |doc|
        model.train(label,doc)
      end
    end

    evaluator = SentimentAnalyser::ModelEvaluator.new(model,test_corpus)
    evaluator.evaluate
    
    puts "#{feature_count};#{evaluator.precision.values.join(";")};#{evaluator.recall.values.join(";")}"
  end
end
