FactoryBot.define do
  factory :user do
    name { "Test User" }
    email { Faker::Internet.email }
    password { "password" }
    role { "Customer" }  
    trait :customer do
      role { "Customer" }
    end

    trait :restaurant do
      role { "Restaurant" }
    end
  end
end
