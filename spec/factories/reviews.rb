FactoryBot.define do
  factory :review do
    content { "Great!" }
    rating { 5 }
    association :user
    association :order
    association :reviewable, factory: :menu_item
  end
end
