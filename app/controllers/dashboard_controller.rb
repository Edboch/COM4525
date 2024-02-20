# frozen_string_literal: true

# Controller for managing the dashboard in the application
class DashboardController < ApplicationController
  def index
    return unless current_user.type == 'Manager'

    @teams = Team.where(owner_id: current_user.id)
  end
end
