# frozen_string_literal: true

# Controller for managing the dashboard in the application
class DashboardController < ApplicationController
  include MetricsHelper

  before_action :check_user_authenticated
  before_action :fill_visitor

  def index
    return unless current_user.manager?

    @teams = Team.where(owner_id: current_user.id)
  end

  private

  def fill_visitor
    @page_visit = find_page_visit
  end
end
