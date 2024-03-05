# frozen_string_literal: true

namespace :page_visits do
  desc 'Collate the number of visits over standard time periods'
  task collate_visits: :environment do
    PageVisitGrouping.destroy_all

    visits_in = { year: 0, month: 0, week: 0 }
    now = Time.current
    earliest = now
    PageVisit.select(:visit_start).order(:visit_start).each do |entry|
      visit = entry.visit_start

      earliest = visit if visit < earliest

      week_start = visit.beginning_of_week
      pvg = PageVisitGrouping.find_or_create_by! period_start: week_start, category: 'week'
      pvg.count += 1
      pvg.save

      days_difference = (now - visit) / 1.day

      if days_difference < 8
        visits_in[:week] += 1
        next
      end

      # Assume the past month starts at the number of days
      # back
      if days_difference < Time.days_in_month(now.month)
        visits_in[:month] += 1
        next
      end

      visits_in[:year] += 1 if days_difference < Time.days_in_year
    end

    PageVisitGrouping.create category: 'earliest', count: 0, period_start: earliest
    PageVisitGrouping.create category: 'past week', count: visits_in[:week]
    PageVisitGrouping.create category: 'past month', count: visits_in[:month]
    PageVisitGrouping.create category: 'past year', count: visits_in[:year]
  end
end
