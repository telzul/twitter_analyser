class SentimentAnalyser::ModelEvaluator

  attr_reader :precision, :recall

  def initialize(model,test_corpus)
    @model = model
    @test_corpus = test_corpus
  end

  def evaluate
    true_positives = Hash.new(0)
    false_negatives = Hash.new(0)
    false_positives = Hash.new(0)

    @test_corpus.data.each_pair do |label,documents|
      documents.each do |document|

        result_label = @model.classify(document)
        if result_label == label
          true_positives[label] += 1
        else
          false_negatives[label] += 1
          false_positives[result_label] += 1
          (@test_corpus.labels-[label,result_label]).each { |l| true_positives[l] += 1 }
        end

      end
    end

    recall=precision=0

    @test_corpus.labels.each do |label|
      recall += true_positives[label] / (true_positives[label] + false_negatives[label]).to_f
      precision += true_positives[label] / (true_positives[label] + false_positives[label]).to_f
    end

    @recall = recall / @test_corpus.labels.count
    @precision = precision / @test_corpus.labels.count
  end

end