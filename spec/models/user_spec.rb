require 'rails_helper'

RSpec.describe User, type: :model do
  it "has a valid factory" do
    expect(build(:user)).to be_valid
  end

  it "is invalid without a name" do
    expect(build(:user, name: nil)).not_to be_valid
  end

  it "is invalid without an email" do
    expect(build(:user, email: nil)).not_to be_valid
  end

  it "is invalid with a duplicate email" do
    create(:user, email: "test@example.com")
    expect(build(:user, email: "test@example.com")).not_to be_valid
  end

  it "is invalid with an invalid role" do
    expect(build(:user, role: "invalid_role")).not_to be_valid
  end

  it "returns true for customer? if role is Customer" do
    user = build(:user, role: "Customer")
    expect(user.customer?).to be true
  end

  it "returns true for restaurant? if role is Restaurant" do
    user = build(:user, role: "Restaurant")
    expect(user.restaurant?).to be true
  end
end
