# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  name                   :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    name { Faker::Name.name }
    password { 'password' } # Faker::Internet.password

    trait :player do
      after(:create) do |user|
        player_role = Role.find_or_create_by!(name: 'Player')
        user.roles << player_role
      end
    end

    trait :manager do
      after(:create) do |user|
        manager_role = Role.find_or_create_by!(name: 'Manager')
        user.roles << manager_role
      end
    end

    trait :site_admin do
      after :create do |user|
        site_admin_role = Role.find_or_create_by! name: 'Site Admin'
        user.roles << site_admin_role
        SiteAdmin.create user_id: user.id
      end
    end
  end
end
