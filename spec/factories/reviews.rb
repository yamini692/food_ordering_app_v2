FactoryBot.define do
  factory :review do
    content { "Great!" }
    rating { 5 }
    association :user
    association :order

    # 👇 Assign a reviewable object (like MenuItem, which supports reviews)
    association :reviewable, factory: :menu_item
  end
end
