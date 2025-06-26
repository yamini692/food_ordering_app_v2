require 'rails_helper'

RSpec.describe Order, type: :model do
  it "has a valid factory" do
    expect(create(:order)).to be_valid
  end

  it "is invalid without a user" do
    expect(build(:order, user: nil)).to_not be_valid
  end

  it "is invalid without a payment_method" do
    expect(build(:order, payment_method: nil)).to_not be_valid
  end

  it "is invalid with an unknown status" do
    expect(build(:order, status: "invalid")).to_not be_valid
  end
end
