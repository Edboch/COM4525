# frozen_string_literal: true

# Controller for managing the dashboard in the application
class DashboardController < ApplicationController
  include AuthenticationHelper
  include MetricsHelper

  before_action :check_user_authenticated
  before_action :fill_visitor

  def index
    @owned_teams = current_user.owned_teams
    @teams = current_user.teams
  end

  private

  def fill_visitor
    @page_visit = find_page_visit
  end
end
