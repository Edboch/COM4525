# frozen_string_literal: true

# Decorator for Team views
class TeamDecorator < ApplicationDecorator
  delegate_all

  def days_until_next_match
    days = object.days_until_next_match

    return 'No upcoming matches' if days == -1

    "Next match in #{days} days"
  end
end
