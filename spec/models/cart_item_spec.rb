require 'rails_helper'

RSpec.describe CartItem, type: :model do
  it "has a valid factory" do
    expect(build(:cart_item)).to be_valid
  end

  it "is invalid without a user" do
    expect(build(:cart_item, user: nil)).not_to be_valid
  end

  it "is invalid without a menu_item" do
    expect(build(:cart_item, menu_item: nil)).not_to be_valid
  end
end
