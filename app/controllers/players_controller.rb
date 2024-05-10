# frozen_string_literal: true

# Controller for managing the dashboard in the application
class PlayersController < ApplicationController
  before_action :authenticate_user!

  def invites
    # send the current players invites to the view
    @invites = UserTeam.where(user_id: current_user.id, accepted: false)
  end

  def upcoming_matches
    owned_teams = Team.where(owner_id: current_user.id)
    joined_teams = current_user.teams.where({ user_teams: { accepted: true } })

    @teams = (owned_teams + joined_teams).uniq
    @matches = Match.where(team: @teams).where('start_time > ?',
                                               Time.zone.now).order(:start_time).page(params[:page]).per(6).decorate
  end
end
