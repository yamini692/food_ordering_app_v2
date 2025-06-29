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

  describe "available attribute boolean handling" do
    it "is valid when available is true" do
      expect(build(:menu_item, raw_available: true)).to be_valid
    end

    it "is valid when available is false" do
      expect(build(:menu_item, raw_available: false)).to be_valid
    end

    it "is valid when available is string 'true'" do
      item = build(:menu_item, raw_available: 'true')
      item.valid?
      expect(item).to be_valid
    end

    it "is valid when available is string 'false'" do
      item = build(:menu_item, raw_available: 'false')
      item.valid?
      expect(item).to be_valid
    end

    it "is invalid when available is an invalid string" do
      item = build(:menu_item, raw_available: 'maybe')
      item.valid?
      expect(item.errors[:available]).to include("must be true or false")
    end

    it "is invalid when available is a random string" do
      item = build(:menu_item, raw_available: 'yesplease')
      item.valid?
      expect(item.errors[:available]).to include("must be true or false")
    end
  end
  describe ".ransackable_associations" do
    it "returns the correct list of associations" do
      expected_associations = %w[
        cart_items
        categories
        order
        order_items
        orders
        reviews
        unbooked_order_items
        user
      ]
      expect(MenuItem.ransackable_associations).to match_array(expected_associations)
    end
  end

  describe ".ransackable_attributes" do
    it "returns all column names" do
      expect(MenuItem.ransackable_attributes).to match_array(MenuItem.column_names)
    end
  end
  describe "#deleted?" do
    it "returns true when deleted_at is present" do
      item = build(:menu_item, deleted_at: Time.current)
      expect(item.deleted?).to be true
    end

    it "returns false when deleted_at is nil" do
      item = build(:menu_item, deleted_at: nil)
      expect(item.deleted?).to be false
    end
  end


end
