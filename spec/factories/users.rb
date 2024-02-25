FactoryBot.define do
  factory :user do
    email { "test@email.com" }
    name { "Test" }
    password { "Password" }

    trait :player do
      id { 0 }
      type { "Player" }
    end

    trait :manager do 
      id { 1 }
      type { "Manager" }
    end
  end
end