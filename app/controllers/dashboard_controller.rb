# frozen_string_literal: true

# Controller for managing the dashboard in the application
class DashboardController < ApplicationController
  include AuthenticationHelper
  include MetricsHelper

  before_action :check_user_authenticated
  before_action :fill_visitor

  def index
    @teams = (current_user.owned_teams + current_user.teams).uniq
  end

  private

  def fill_visitor
    @page_visit = find_page_visit
  end
end
