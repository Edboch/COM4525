class MetricsController < ApplicationController
  include MetricsHelper

  def update_visitor
    return unless are_visitor_params_valid?

    page_visit = PageVisit.find_or_create_by! id: params[:visitor_id]
    return if page_visit.nil?

    tz = params[:time_zone]
    to_start = !params[:start_time].nil? && page_visit.visit_start.nil?
    timestamp = to_start ? params[:start_time] : params[:end_time]
    datetime = get_timezone_time tz, timestamp.to_i

    if to_start
      page_visit.visit_start = datetime
    else
      page_visit.visit_end = datetime
    end

    page_visit.save
  end

  private

  def are_visitor_params_valid?
    if params[:visitor_id].nil?
      logger.err 'No visitor id provided'
      return false
    end

    unless PageVisit.exists? id: params[:visitor_id]
      logger.err "Visitor ID #{params[:visitor_id]} is not valid"
      return false
    end

    if params[:time_zone].nil?
      logger.err 'No time_zone passed'
      return false
    end

    params[:time_zone]

    if params[:start_time].nil? && params[:end_time].nil?
      logger.err 'No time field'
      return false
    end

    true
  end
end
