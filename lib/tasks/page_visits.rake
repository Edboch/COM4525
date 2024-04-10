# frozen_string_literal: true

namespace :page_visits do
  desc 'Collate the number of visits over standard time periods'
  task collate: :environment do
    PageVisitGrouping.destroy_all

    visits_in = { year: 0, month: 0, week: 0 }
    now = Time.current
    earliest = now

    diffs = []

    # Assume the past month starts at the number of days back
    len_month = Time.days_in_month now.month
    len_year = Time.days_in_year
    PageVisit.select(:visit_start).order(:visit_start).each do |entry|
      visit = entry.visit_start

      earliest = visit if visit < earliest

      day_start = visit.beginning_of_day
      pvg = PageVisitGrouping.find_or_create_by! period_start: day_start, category: 'day'
      pvg.count += 1
      pvg.save

      days_difference = (now - visit) / 1.day
      diffs.append days_difference

      next unless days_difference <= len_year

      visits_in[:year] += 1

      next unless days_difference <= len_month

      visits_in[:month] += 1

      visits_in[:week] += 1 if days_difference < 8
    end

    PageVisitGrouping.create category: 'earliest', count: 0, period_start: earliest
    PageVisitGrouping.create category: 'past week', count: visits_in[:week]
    PageVisitGrouping.create category: 'past month', count: visits_in[:month]
    PageVisitGrouping.create category: 'past year', count: visits_in[:year]
    num_weeks = ((now - earliest.beginning_of_week) / 1.week).to_i

    total = PageVisit.count
    PageVisitGrouping.create category: 'avg week', count: (total / num_weeks)
    PageVisitGrouping.create category: 'avg month', count: (total / (num_weeks / 4))
    PageVisitGrouping.create category: 'avg year', count: (total / (num_weeks / 52))
  end
end
