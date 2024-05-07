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
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :user_teams, dependent: :destroy
  has_many :teams, through: :user_teams

  has_many :player_ratings, dependent: :destroy
  has_many :match_events, dependent: :nullify
  has_many :rating_matches, through: :player_ratings, source: :match
  has_many :event_matches, through: :match_events, source: :match

  def owner_of_team?(team, user)
    team.owner_id == user.id
  end

  # checks whether the user has the privileges of staff
  # TODO change this to fit CanCan authorisation
  def staff_of_team?(team, user)
    return true if team.owner_id == user.id

    user_teams.joins(:roles, :team)
              .exists?(teams: { id: team.id }, roles: { type: 1 })
  end

  def player_of_team?(team)
    user_teams.joins(:roles, :team)
              .exists?(teams: { id: team.id }, roles: { type: 0 })
  end

  has_many :owned_teams, class_name: :Team, foreign_key: :owner_id, dependent: :destroy, inverse_of: :owner do
    def destroy(team)
      # TODO
    end
  end

  def goals_scored_for_team(team)
    count_match_event_of_type_for_team(:goal, team)
  end

  def assists_for_team(team)
    count_match_event_of_type_for_team(:assist, team)
  end

  def saves_made_for_team(team)
    count_match_event_of_type_for_team(:save_made, team)
  end

  def fouls_for_team(team)
    count_match_event_of_type_for_team(:foul, team)
  end

  def yellows_for_team(team)
    count_match_event_of_type_for_team(:yellow, team)
  end

  def reds_for_team(team)
    count_match_event_of_type_for_team(:red, team)
  end

  def goals_conceded_for_team(team)
    count_match_event_of_type_for_team(:goal_conceded, team)
  end

  def penalties_won_for_team(team)
    count_match_event_of_type_for_team(:penalty_won, team)
  end

  def penalties_conceded_for_team(team)
    count_match_event_of_type_for_team(:penalty_conceded, team)
  end

  def offside_for_team(team)
    count_match_event_of_type_for_team(:offside, team)
  end

  def count_match_event_of_type_for_team(event_type, team)
    event_matches
      .where(match_events: { event_type: MatchEvent.event_types[event_type], user_id: id })
      .where(team_id: team)
      .count
  end

  def accepted_team?(team)
    user_teams.find_by(user_id: id, team_id: team)&.accepted || false
  end

  has_one :site_admin, dependent: :destroy
end
