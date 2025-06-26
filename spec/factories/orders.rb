FactoryBot.define do
  factory :order do
    association :user              # 👈 This creates a user and assigns it
    association :menu_item         # 👈 Add this if order belongs_to menu_item
    payment_method { "Card" }
    status { "placed" }
  end
end
