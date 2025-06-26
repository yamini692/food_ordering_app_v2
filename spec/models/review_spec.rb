require 'rails_helper'

RSpec.describe Review, type: :model do
  it "has a valid factory" do
    expect(build(:review)).to be_valid
  end

  it "is invalid without content" do
    expect(build(:review, content: nil)).not_to be_valid
  end

  it "is invalid without a rating" do
    expect(build(:review, rating: nil)).not_to be_valid
  end

  it "is invalid with a rating less than 1" do
    expect(build(:review, rating: 0)).not_to be_valid
  end

  it "is invalid with a rating greater than 5" do
    expect(build(:review, rating: 6)).not_to be_valid
  end
end
