FactoryBot.define do
  factory :menu_item do
    name { "Burger" }
    price { 150 }
    available { true }
    description { "Tasty chicken burger" }
    association :user
  end
end
