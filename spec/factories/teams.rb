FactoryBot.define do
  factory :team do
    name { "TeamName" }
    location_name { "TeamCity" }
    owner_id { 1 } # matches the manager factorybot in /factories/user.rb
  end
end