require 'csv'
class SentimentAnalyser::SentimentLexiconClassifier

  def initialize(word_list)
    @word_list = Hash.new(0)

    CSV.open(File.join(Rails.root,"lib/sentiment_wordlist_2.csv"), :col_sep => "\t").each do |csv|
      @word_list[csv[0]] = csv[1].to_f
    end
  end

  def classify(content)
    data = content.uniq

    counter = 1
    sentiment_intensity = 0

    data.map do |word|
      counter +=1 if @word_list.keys.include? word

      p "score of #{word} is #{@word_list[word]}"

      sentiment_intensity += @word_list[word]
    end

    sentiment_intensity /= counter.to_f

    return "neutral" if (0.45..0.55).include? sentiment_intensity

    sentiment_intensity > 0.5 ? "positive":"negative"
  end
end