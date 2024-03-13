# frozen_string_literal: true

# Controller for managing the dashboard in the application
class PlayersController < ApplicationController
  def invites
    return unless current_user.player?

    # send the current players invites to the view
    @invites = UserTeam.where(user_id: current_user.id, accepted: false)
  end

  def upcoming_matches
    user_teams = UserTeam.where(user_id: current_user.id, accepted: true)
    teams = []
    matches = []
    user_teams.each do |user_team|
      teams.append(Team.find_by(id: user_team.team_id))
    end
    teams.each do |team|
      matches += Match.where(team_id: team.id)
    end
    @matches = matches
  end
end
