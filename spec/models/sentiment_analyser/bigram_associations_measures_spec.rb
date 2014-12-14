require 'rails_helper'

RSpec.describe SentimentAnalyser::BigramAssociationMeasures, type: :model do

  describe "#contingency_table" do
    it "calculates the right table" do
      measures = SentimentAnalyser::BigramAssociationMeasures.new(2,10,9,20)

      expect(measures.contingency_table).to eql(
                                               [[2,8, 10]]+
                                               [[7,3, 10]]+
                                               [[9,11,20]]
                                              )
    end
  end

  describe "#expected_values" do
    it "calculates the right expected values" do
      measures = SentimentAnalyser::BigramAssociationMeasures.new(2,10,9,20)

      expect(measures.expected_values).to eql(
                                               [[4.5,5.5]]+
                                               [[4.5,5.5]]
                                            )
    end
  end

  describe "#chi_square" do
    context "the variables are statistically independent" do
      it "returns 0" do
        measures = SentimentAnalyser::BigramAssociationMeasures.new(4.5,10,9,20)
        expect(measures.chi_square).to be(0.0)
      end
    end

    context "the variables are dependent" do
      it "returns a value gt 0" do
        measures = SentimentAnalyser::BigramAssociationMeasures.new(2,10,9,20)
        expect(measures.chi_square).to be(5.05050505050505)
      end
    end
  end


end