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

  # check whether a created match has happened
  # for editing the match goals
  def match_in_past?(match)
    return false if match.start_time.nil?

    match.start_time.past?
  end
end
