# frozen_string_literal: true

# Decorator for the Team Role model
class TeamRoleDecorator < ApplicationDecorator
  delegate_all

  def type_name
    return 'Staff' if staff?

    'Regular'
  end
end
