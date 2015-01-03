require 'rails_helper'

RSpec.describe SentimentAnalyser::FeatureSelector, type: :model do

  before(:each) do
    data = {
        :positive => [%w{wunderbar super toll}, %w{toll wort gute dinge}],
        :negative => [%w{schlecht mies schrecklich }, %w{schrecklich wort ohne gute dinge}]
    }
    @corpus= SentimentAnalyser::LabeledCorpus.new(data)
    @selector = SentimentAnalyser::FeatureSelector.new(@corpus)
  end

  describe "#total_ngram_count" do
    it "counts all ngrams" do
      expect(@selector.total_ngram_count).to be 15
    end
  end

  describe "#ngram_fd" do
    it "counts all occurences of a ngram" do
      expect(@selector.ngram_fd("dinge")).to be 2
      expect(@selector.ngram_fd("super")).to be 1
    end

    it "stores the result in an instance variable" do
      @selector.ngram_fd("dinge")
      expect(@selector.instance_variable_get("@ngram_fd")).not_to be nil
    end
  end

  describe "#label_fd" do
    it "counts all ngrams for a given label" do
      expect(@selector.label_fd(:positive)).to be 7
      expect(@selector.label_fd(:negative)).to be 8
    end

    it "stores the result in an instance variable" do
      @selector.label_fd(:positive)
      expect(@selector.instance_variable_get("@label_fd")[:positive]).not_to be nil
    end
  end

  describe "#label_ngram_fd" do
    it "counts all occurences of a given ngram for each label" do
      expect(@selector.label_ngram_fd(:positive,"toll")).to be 2
      expect(@selector.label_ngram_fd(:negative,"toll")).to be 0
    end

    it "stores the result in an instance variable" do
      @selector.label_ngram_fd(:positive,"toll")
      expect(@selector.instance_variable_get("@label_ngram_fd")[:positive]["toll"]).to be 2
    end
  end

  describe "#significance" do
    it "calculates the chi_square score for every label for a given ngram" do
      bigram_measure = double("bigram_measure")
      expect(bigram_measure).to receive(:chi_square).twice.and_return(5,0)

      expect(SentimentAnalyser::BigramAssociationMeasures).to receive(:new).with(2,2,7,15).and_return(bigram_measure)
      expect(SentimentAnalyser::BigramAssociationMeasures).to receive(:new).with(0,2,8,15).and_return(bigram_measure)

      expect(@selector.significance("toll")).to be 5
    end
  end

  describe "#ngrams_sorted" do
    it "calculates to significance for all ngrams" do
      expect(@selector).to receive(:significance).exactly(10).times.and_return(0)
      @selector.ngrams_sorted
    end

    it "sorts the ngrams by significance" do
      allow(@selector).to receive(:significance).and_return(0)
      allow(@selector).to receive(:significance).with("super").and_return(15)
      allow(@selector).to receive(:significance).with("wunderbar").and_return(10)

      sorted_ngrams = @selector.ngrams_sorted
      expect(sorted_ngrams.first).to eql "super"
      expect(sorted_ngrams[1]).to eql "wunderbar"
    end
  end

  describe "#significant_ngrams" do
    it "returns the n most significant ngrams" do
      allow(@selector).to receive(:ngrams_sorted).and_return(["super","wunderbar","toll","schrecklich"])
      expect(@selector.significant_ngrams(3)).to eql(["super","wunderbar","toll"])
    end
  end
end