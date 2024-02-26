# frozen_string_literal: true

# Controller for managing the dashboard in the application
class DashboardController < ApplicationController
  before_action :check_user_authenticated

  def index
    return unless current_user.manager?

    @teams = Team.where(owner_id: current_user.id)
  end
end
