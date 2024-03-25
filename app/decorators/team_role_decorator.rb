# frozen_string_literal: true

# Decorator for the Team Role model
class TeamRoleDecorator < ApplicationDecorator
  delegate_all

  def type_name
    return 'Regular' if regular?
    return 'Staff' if staff?

    'Managerial' if managerial?
  end
end
