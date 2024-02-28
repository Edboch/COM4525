# frozen_string_literal: true

# Controller for the admin page
class AdminController < ApplicationController
  layout false
  before_action :check_access_rights

  ####################
  # GET

  def index; end

  ############
  # POST

  def retrieve_popularity_metrics
    response = { total: PageVisit.count, avgm: 0, avgw: 0 }
    render json: response
  end

  private

  ############
  # ACTIONS

  def check_access_rights
    # return if !user_signed_in? || !current_user.decorate.site_admin?
    # return if can? :manage, :admin_dashboard
    authorize! :manage, :admin_dashboard
    # redirect_to root_url
  end
end
