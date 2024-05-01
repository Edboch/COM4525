# frozen_string_literal: true

# Decorator for Dashboard views in the application
class DashboardDecorator < ApplicationDecorator
  delegate_all

  def initialize(team, matches)
    @team = team
    @matches = matches
  end

  def days_until_next_match
    next_match_date = @matches.where('start_time > ?', Time.zone.now)
                              .order(start_time: :asc)
                              .pick(:start_time)
    return 'No upcoming matches' unless next_match_date

    (next_match_date.to_date - Time.zone.today).to_i
  end
end
