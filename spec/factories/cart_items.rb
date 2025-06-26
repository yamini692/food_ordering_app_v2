FactoryBot.define do
  factory :cart_item do
    association :user
    association :menu_item
  end
end
