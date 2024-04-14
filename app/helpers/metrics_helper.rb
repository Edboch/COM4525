# frozen_string_literal: true

# Provides helper functions for tracking metrics throughout the app
module MetricsHelper
  def get_timezone_time(time_zone, epochs)
    datetime = nil
    Time.use_zone time_zone do
      datetime = Time.zone.at epochs / 1000
    end
    datetime
  end

  def find_site_visit
    unless session[:visitor_id].nil?
      logger.info session[:visitor_id]
      pv = SiteVisit.find session[:visitor_id]
      return pv unless pv.nil?
    end

    pv = SiteVisit.create
    session[:visitor_id] = pv.id
    pv
  end

  def popularity_data
    {
      total: SiteVisit.count,
      avg_week: SiteVisitGrouping.where(category: 'avg week').first&.count,
      avg_month: SiteVisitGrouping.where(category: 'avg month').first&.count,
      avg_year: SiteVisitGrouping.where(category: 'avg year').first&.count,
      past_week: SiteVisitGrouping.where(category: 'past week').first&.count,
      past_month: SiteVisitGrouping.where(category: 'past month').first&.count,
      past_year: SiteVisitGrouping.where(category: 'past year').first&.count
    }
  end
end
