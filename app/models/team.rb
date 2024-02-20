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
class Team < ApplicationRecord
  validates :location_name, presence: true
  validates :name, presence: true
  validates :owner_id, presence: true

  has_many :user_teams, dependent: :destroy
  has_many :users, through: :user_teams
end
