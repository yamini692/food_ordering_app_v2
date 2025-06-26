require 'rails_helper'

RSpec.describe MenuItem, type: :model do
  it "has a valid factory" do
    expect(build(:menu_item)).to be_valid
  end

  it "is invalid without a name" do
    expect(build(:menu_item, name: nil)).to_not be_valid
  end

  it "is invalid with price <= 0" do
    expect(build(:menu_item, price: 0)).to_not be_valid
  end

  it "is invalid without a description" do
    expect(build(:menu_item, description: nil)).to_not be_valid
  end
end
