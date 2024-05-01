# frozen_string_literal: true

# Controller for managing the dashboard in the application
class DashboardController < ApplicationController
  include AuthenticationHelper
  include MetricsHelper

  before_action :check_user_authenticated
  before_action :fill_visitor

  def index
    owned_teams = Team.where(owner_id: current_user.id)
    joined_teams = current_user.teams.where({ user_teams: { accepted: true } })

    @teams = (owned_teams + joined_teams).uniq
    @matches = Match.where(team: @teams)
  end

  private

  def fill_visitor
    @site_visit = find_site_visit
  end
end
