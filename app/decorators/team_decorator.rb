# frozen_string_literal: true

# Decorator for Team views
class TeamDecorator < ApplicationDecorator
  delegate_all

  def formatted_created_at
    object.created_at.strftime('%d %B %Y')
  end

  def played_count
    object.matches.where('start_time < ?', Time.current).count
  end

  def win_count
    object.matches
          .where('start_time < ?', Time.current)
          .where('goals_for > goals_against')
          .count
  end

  def draw_count
    object.matches
          .where('start_time < ?', Time.current)
          .where('goals_for = goals_against')
          .count
  end

  def loss_count
    object.matches
          .where('start_time < ?', Time.current)
          .where('goals_for < goals_against')
          .count
  end

  def days_until_next_match
    next_match_date = object.matches.where('start_time > ?', Time.zone.now)
                            .order(start_time: :asc)
                            .pick(:start_time)
    return 'No upcoming matches' unless next_match_date

    days = (next_match_date.to_date - Time.zone.today).to_i

    "Next match in #{days} days"
  end
end
