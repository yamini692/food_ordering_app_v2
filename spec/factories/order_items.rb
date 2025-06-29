FactoryBot.define do
  factory :order_item do
    order
    menu_item
    quantity { 1 }
    booked { false }
  end
end
