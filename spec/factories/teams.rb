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
    transient do
      owner do
        num_users = User.count
        User.offset(rand(num_users)).first
      end
    end

    location_name { Faker::Address.city }
    name do
      name = Faker::Creature::Animal.name.pluralize.capitalize
      if rand > 0.3
        "#{location_name} #{name}"
      else
        "The #{name}"
      end
    end

    owner_id { owner.id }
  end
end
