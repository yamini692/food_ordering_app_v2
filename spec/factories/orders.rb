FactoryBot.define do
  factory :order do
    association :user             
    association :menu_item        
    payment_method { "Card" }
    status { "placed" }
  end
end
