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
    name { Faker::Creature::Animal.name }
    location_name { Faker::Address.city }
    owner_id { 1 }
  end
end
