# frozen_string_literal: true

# Decorator for User views
class UserDecorator < ApplicationDecorator
  delegate_all

  def team_status(team)
    object.accepted_team?(team) ? 'Joined' : 'Pending'
  end

  def admin?
    !object.site_admin.nil?
  end
end
