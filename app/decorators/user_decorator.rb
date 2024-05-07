# frozen_string_literal: true

# Decorator for User views
class UserDecorator < ApplicationDecorator
  delegate_all

  def team_status(team)
    object.accepted_team?(team) ? 'Joined' : 'Pending'
  end
end
