# frozen_string_literal: true

# Controller for the admin page
class AdminController < ApplicationController
  layout 'admin'
  before_action :check_access_rights

  ####################
  # GET

  def index
    @users = user_data
  end

  ############
  # POST

  def retrieve_popularity_metrics
    response = { total: PageVisit.count, avgm: 0, avgw: 0 }
    render json: response
  end

  def retrieve_users
    response = user_data
    render json: response
  end

  def update_user
    user = User.find_by id: params[:id]
    return if user.nil?

    user.name = params[:name]
    user.email = params[:email]

    # TODO: Remeber to remove/add the site admin role when changing user roles

    result = user.save
    render json: { success: result }
  end

  private

  def user_data
    # Rather than returning separate arrays of the different types, we'll
    # do the sorting in the SQL query, which will be configurable by url params
    # TODO: Implement sorting options
    #       The intended default sorting is intended to be Player > Manager > Admin
    User.select(:id, :name, :email).includes(:roles)
        .sort_by { |u| u.roles.pluck(:name).sort.reverse }
        .map do |user|
          {
            id: user.id, name: user.name, email: user.email,
            roles: user.roles.pluck(:name).sort.reverse
          }
        end
  end

  ############
  # ACTIONS

  def check_access_rights
    # return if !user_signed_in? || !current_user.decorate.site_admin?
    # return if can? :manage, :admin_dashboard
    authorize! :manage, :admin_dashboard
    # redirect_to root_url
  end
end
