# frozen_string_literal: true

# == Schema Information
#
# Table name: teams
#
#  id            :bigint           not null, primary key
#  location_name :string
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  owner_id      :bigint
#
FactoryBot.define do
  factory :team do
    location_name { Faker::Address.city }
    name do
      name = Faker::Creature::Animal.name.pluralize.capitalize
      if rand > 0.3
        "#{location_name} #{name}"
      else
        name
      end
    end
    # Wanted to set this to be nil, but it seems like it would
    # would be more hassle than it's worth
    owner_id { 0 }

    trait :random_manager do
      owner_id do
        num_users = User.count
        User.offset(rand(num_users)).first.id
      end
    end
  end
end
