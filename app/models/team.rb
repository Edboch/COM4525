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
#
class Team < ApplicationRecord
  validates :name, presence: true
  validates :location_name, presence: true

  has_many :user_teams, dependent: :destroy
  has_many :users, through: :user_teams
end
