require 'rails_helper'

RSpec.describe SentimentAnalyser::NaiveBayesClassifier, type: :model do

  describe "#train" do
    before(:each) do
      @cls = SentimentAnalyser::NaiveBayesClassifier.new([:positive,:negative],%w{foo bar hello world})
    end

    it "increases the document count for the specified label" do
      @cls.instance_variable_get("@label_document_count")[:positive]=10
      @cls.train(:positive,%w{a test})
      expect(@cls.instance_variable_get("@label_document_count")[:positive]).to be 11
    end

    it "increases the label feature count for the specified features" do
      @cls.instance_variable_get("@label_feature_count")[:positive]["foo"]=10
      @cls.train(:positive,%w{foo})
      expect(@cls.instance_variable_get("@label_feature_count")[:positive]["foo"]).to be 11
    end

    it "ignores ngrams not in the feature list" do
      @cls.train(:positive,%w{baz})
      expect(@cls.instance_variable_get("@label_feature_count")[:positive]["baz"]).to be 1
    end

  end

  describe "#test" do
    before(:all) do
      @cls = SentimentAnalyser::NaiveBayesClassifier.new([:positive,:negative],%w{pos positive neutral negative neg})
      @cls.instance_variable_set("@label_document_count",{:positive => 4, :negative => 5})
      @cls.instance_variable_set("@label_feature_count",
                                  {
                                    :positive => { "pos" => 3, "positive" => 4, "neutral" => 2},
                                    :negative => { "neg" => 3, "negative" => 4, "neutral" => 2, "positive" => 1}
                                  }
                                )
    end


    it "calculates the correct probability for content to be classified with the given label" do
      expect(@cls.test(:positive,%w{positive neutral})).to be(Math.log(4/5.0) + Math.log(1.0 / (1/5.0)) + Math.log((2.0/4)/(2.0/5)))
      expect(@cls.test(:negative,%w{positive neutral})).to be(Math.log(5/4.0) + Math.log((1/5.0) / 1.0) + Math.log((2.0/5)/(2.0/4)))
    end
  end

  describe "#classify" do
    before(:each) do
      @cls = SentimentAnalyser::NaiveBayesClassifier.new([:positive,:negative],%w{foo bar hello world})
    end

    it "runs test for each label until the value is > 0" do
      expect(@cls).to receive(:test).with(:positive,%w{foo bar}).and_return(-1)
      expect(@cls).to receive(:test).with(:negative,%w{foo bar}).and_return(1.5)
      expect(@cls.classify(%w{foo bar baz})).to be :negative
    end
  end

end