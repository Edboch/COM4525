# frozen_string_literal: true

# == Schema Information
#
# Table name: matches
#
#  id            :bigint           not null, primary key
#  goals_against :integer
#  goals_for     :integer
#  location      :string           not null
#  opposition    :string           not null
#  start_time    :datetime         not null
#  status        :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  team_id       :bigint           default(1), not null
#
# Indexes
#
#  index_matches_on_team_id  (team_id)
#
# Foreign Keys
#
#  fk_rails_...  (team_id => teams.id)
#
class Match < ApplicationRecord
  belongs_to :team
  has_many :player_ratings, dependent: :destroy
  has_many :match_events, dependent: :destroy
  has_many :users, through: :team

  # get the result as a string for displaying in fixture list
  def result
    return '' if goals_for.nil? || goals_against.nil?

    if goals_for > goals_against
      'win'
    elsif goals_for < goals_against
      'loss'
    else
      'draw'
    end
  end

  # get the scoreline for displaying in fixture list
  def scoreline
    "#{goals_for}-#{goals_against}"
  end
end
