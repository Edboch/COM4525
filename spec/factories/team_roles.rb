# frozen_string_literal: true

# == Schema Information
#
# Table name: team_roles
#
#  id   :bigint           not null, primary key
#  name :string           not null
#  type :integer
#
FactoryBot.define do
  factory :team_role do
    trait :manager do
      name { 'Manager' }
      type { :staff }
    end

    trait :player do
      name { 'Player' }
      type { :regular }
    end
  end
end
