require 'rails_helper'

RSpec.describe Tweet, type: :model do

  it "may have replies" do
    t1 = Tweet.create(text: "one")
    t2 = Tweet.create(text: "two", reply_to: t1)
    t3 = Tweet.create(text: "three", reply_to: t1)

    expect(t1.replies.count).to eq(2)
  end

end
