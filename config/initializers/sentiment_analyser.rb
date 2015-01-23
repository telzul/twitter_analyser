require 'sentiment_analyser/naive_bayes_classifier'

SentimentAnalyser.configure do |config|
  model = YAML.load(File.open(File.join(Rails.root,"config","model.yml")))
  model.try(:ensure_default_values)

  config.model = model
  config.segmentiser = SentimentAnalyser::NGramSegmentizer.new(:n => 1)
end