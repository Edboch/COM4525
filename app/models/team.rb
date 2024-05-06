# frozen_string_literal: true

# == Schema Information
#
# Table name: teams
#
#  id            :bigint           not null, primary key
#  location_name :string
#  name          :string
#  team_name     :string
#  url           :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  owner_id      :bigint
#
class Team < ApplicationRecord
  validates :location_name, presence: true
  validates :name, presence: true

  has_many :user_teams, dependent: :destroy
  has_many :users, -> { where(user_teams: { accepted: true }) }, through: :user_teams

  has_many :matches, dependent: :destroy

  has_many :team_activities, dependent: :destroy

  belongs_to :owner, class_name: :User, inverse_of: :owned_teams

  def played_count
    matches.where('start_time < ?', Time.current).count
  end

  def win_count
    matches
      .where('start_time < ?', Time.current)
      .where('goals_for > goals_against')
      .count
  end

  def draw_count
    matches
      .where('start_time < ?', Time.current)
      .where('goals_for = goals_against')
      .count
  end

  def loss_count
    matches
      .where('start_time < ?', Time.current)
      .where('goals_for < goals_against')
      .count
  end

  def days_until_next_match
    next_match_date = matches.where('start_time > ?', Time.zone.now)
                             .order(start_time: :asc)
                             .pick(:start_time)
    return -1 unless next_match_date

    (next_match_date.to_date - Time.zone.today).to_i
  end

  def manager
    User.find_by(id: owner_id)
  end

  def player_count
    users.where(user_teams: { accepted: true }).count
  end
end
