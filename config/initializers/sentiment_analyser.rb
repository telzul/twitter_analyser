require 'sentiment_analyser/naive_bayes_classifier'

SentimentAnalyser.configure do |config|
  config.model = YAML.load(File.open(File.join(Rails.root,"config","model.yml")))
  config.segmentiser = SentimentAnalyser::NGramSegmentizer.new(:n => 1)
end