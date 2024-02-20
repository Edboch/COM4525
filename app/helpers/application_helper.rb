# frozen_string_literal: true

# Application-wide helper module
module ApplicationHelper
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def find_page_visit
    unless session[:visitor_id].nil?
      logger.info session[:visitor_id]
      pv = PageVisit.find session[:visitor_id]
      return pv unless pv.nil?
    end

    pv = PageVisit.create
    session[:visitor_id] = pv.id
    pv
  end
end
