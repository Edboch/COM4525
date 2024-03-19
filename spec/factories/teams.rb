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
    name { 'TeamName' }
    location_name { 'TeamCity' }
    owner_id { 1 } # matches the manager factorybot in /factories/user.rb
    id { 0 }
  end
end
