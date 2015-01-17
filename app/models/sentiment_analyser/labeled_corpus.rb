class SentimentAnalyser::LabeledCorpus
  include Enumerable

  attr_reader :data

  def initialize(data)
    @data = data
  end

  def labels
    @data.keys
  end

  def documents(label)
    @data[label] || []
  end

  def self.from_csv(corpus_file, segmentizer = SentimentAnalyser::NGramSegmentizer.new(:n => 2,:lang => :en))
    require 'csv'
    data = Hash.new {|h,k| h[k]=[]}
    CSV.foreach(corpus_file) do |csv|
      data[csv[0]] << segmentizer.segmentize(csv[1])
    end

    new(data)
  end
end