# frozen_string_literal: true

# Decorator for matches
class MatchDecorator < ApplicationDecorator
  delegate_all

  # returns the displayable title for the match
  # e.g. 'Aston Villa 2-1 Brighton'
  def match_header
    return "#{object.team.name} v #{object.opposition}" if object.start_time > Time.current

    "#{object.team.name} #{object.goals_for}-#{object.goals_against} #{object.opposition}"
  end
end
