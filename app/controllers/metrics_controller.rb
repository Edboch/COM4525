class MetricsController < ApplicationController
  include MetricsHelper

  def update_visitor
    return unless are_visitor_params_valid?

    tz = params[:time_zone]
    if !params[:end_time].nil?
      datetime = get_timezone_time tz, params[:end_time].to_i
      @page_visit.visit_end = datetime
    elsif @page_visit.visit_start.nil?
      datetime = get_timezone_time tz, params[:start_time].to_i
      @page_visit.visit_start = datetime
    end

    @page_visit.save
  end

  private

  def are_visitor_params_valid?
    if params[:visitor_id].nil?
      logger.err 'No visitor id failed'
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
