require 'rails_helper'
include ActiveSupport::Testing::TimeHelpers

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

  describe "#soft_delete" do
    it "sets deleted_at to current time" do
      order = create(:order)
      expect(order.deleted_at).to be_nil

      now = Time.current
      travel_to now do
        order.soft_delete
        expect(order.deleted_at.to_i).to eq(now.to_i)
      end
    end
  end
   describe "#deleted?" do
    it "returns true when deleted_at is present" do
      order = build(:order, deleted_at: Time.current)
      expect(order.deleted?).to be true
    end

    it "returns false when deleted_at is nil" do
      order = build(:order, deleted_at: nil)
      expect(order.deleted?).to be false
    end
  end
   describe ".unbooked_for_restaurant" do
    it "returns orders with unbooked order items for a given restaurant" do
      restaurant = create(:user, :restaurant)
      customer = create(:user, :customer)
      menu_item = create(:menu_item, user: restaurant)

      order = create(:order, user: customer, menu_item: menu_item, status: "placed")
      create(:order_item, order: order, menu_item: menu_item, booked: false)

      result = Order.unbooked_for_restaurant(restaurant.id)

      expect(result).to include(order)
    end

    it "does not return orders if all items are booked or status is not placed" do
      restaurant = create(:user, :restaurant)
      customer = create(:user, :customer)
      menu_item = create(:menu_item, user: restaurant)

      # Booked item
      order1 = create(:order, user: customer, menu_item: menu_item, status: "placed")
      create(:order_item, order: order1, menu_item: menu_item, booked: true)

      # Wrong status
      order2 = create(:order, user: customer, menu_item: menu_item, status: "delivered")
      create(:order_item, order: order2, menu_item: menu_item, booked: false)

      result = Order.unbooked_for_restaurant(restaurant.id)

      expect(result).to_not include(order1)
      expect(result).to_not include(order2)
    end
  end
end
