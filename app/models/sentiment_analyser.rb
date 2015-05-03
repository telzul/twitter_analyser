class SentimentAnalyser
  def self.configure(&block)
    yield(config)
  end

  def self.config
    @config ||= Configuration.new
  end

  def self.classify(text)
    config.model.classify(config.segmentiser.segmentize(text))
  end

  def self.model
    self.config.model
  end

  class Configuration
    attr_accessor :model, :segmentiser
  end
end