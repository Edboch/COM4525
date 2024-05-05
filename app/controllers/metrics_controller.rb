# frozen_string_literal: true

# Controller for managing metrics collected across the web application
class MetricsController < ApplicationController
  include MetricsHelper

  def update_visitor
    return unless are_visitor_params_valid?

    site_visit = SiteVisit.find_or_create_by! id: params[:visitor_id]
    return if site_visit.nil?

    tz = params[:time_zone]
    to_start = !params[:start_time].nil? && site_visit.visit_start.nil?
    timestamp = to_start ? params[:start_time] : params[:end_time]
    datetime = get_timezone_time tz, timestamp.to_i

    if to_start
      site_visit.visit_start = datetime
    else
      site_visit.visit_end = datetime
    end

    site_visit.save
  end

  private

  def are_visitor_params_valid?
    if params[:visitor_id].nil?
      logger.err 'No visitor id provided'
      return false
    end

    unless SiteVisit.exists? id: params[:visitor_id]
      logger.err "Visitor ID #{params[:visitor_id]} is not valid"
      return false
    end

    if params[:time_zone].nil?
      logger.err 'No time_zone passed'
      return false
    end

    if params[:start_time].nil? && params[:end_time].nil?
      logger.err 'No time field'
      return false
    end

    true
  end
end
