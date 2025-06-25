class OrderItem < ApplicationRecord
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :booked, inclusion: { in: [true, false] }

  belongs_to :order
  belongs_to :menu_item
  scope :unbooked, -> {
  joins(:order).where(orders: { status: "placed" }, booked: [ false, nil ])
}
  # all order_item belong to particular restaurant
  scope :belonging_to_restaurant, ->(restaurant_id) {
  joins(:menu_item).where(menu_items: { user_id: restaurant_id })
}
end
