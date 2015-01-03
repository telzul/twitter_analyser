class SentimentAnalyser::NGramSegmentizer

  def initialize(n,lang=:en)
    @n = n
    @segmentizer_class = Tokenizer::Tokenizer.new(lang)
  end

  def segmentize(text)
    text.gsub!(/((@|#)(\w+))|\d|https?\:\/\/(\w|\.|\?|\%|\/|\#|\=)+/,"")
    @segmentizer_class.
        tokenize(text).
        map(&:downcase).
        reject {|b| %w{, ; . : - _ < > ( ) [ ] ! ? = " § $ % & /}.include?(b)}.
        reject(&:blank?).
        each_cons(@n).to_a
  end
end