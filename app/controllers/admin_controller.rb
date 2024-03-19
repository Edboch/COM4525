# frozen_string_literal: true

# Controller for the admin page
class AdminController < ApplicationController
  include MetricsHelper

  layout 'admin'
  before_action :check_access_rights

  ####################
  # GET

  def index
    @users = user_data
    @visit_metrics = popularity_data
    @earliest = PageVisitGrouping.where(category: 'earliest').first&.period_start || 1.day.ago
  end

  ############
  # POST

  def retrieve_popularity_metrics
    render json: popularity_data
  end

  def retrieve_popularity_range
    if params[:start].nil? || params[:end].nil?
      render body: '', status: :unprocessible_entity
      return
    end

    time_zone = params[:time_zone] || Time.time_zone
    start_time = get_timezone_time time_zone, params[:start].to_i
    end_time = get_timezone_time time_zone, params[:end].to_i

    total = PageVisitGrouping.where(category: 'day').where(period_start: (start_time..end_time)).pluck(:count).sum

    render json: { total: total }
  end

  def retrieve_users
    response = user_data
    render json: response
  end

  def update_user
    user = User.find_by(id: params[:id]).decorate
    if user.nil?
      render json: { success: false, message: "Could not find user by ID #{params[:id]}" }
      return
    end

    user.name = params[:name]
    user.email = params[:email]
    user.update_roles params[:roles]

    result = user.save
    render json: { success: result }
  end

  def new_user
    # TODO: Send email with current password telling the user to update it

    user = User.create name: params[:name], email: params[:email], password: params[:password]
    user.decorate.update_roles params[:roles]

    render json: { success: true }
  end

  def remove_user
    user = User.find_by id: params[:id]
    user&.destroy
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

  def popularity_data
    {
      total: PageVisit.count,
      avg_week: PageVisitGrouping.where(category: 'avg week').first&.count,
      avg_month: PageVisitGrouping.where(category: 'avg month').first&.count,
      avg_year: PageVisitGrouping.where(category: 'avg year').first&.count,
      past_week: PageVisitGrouping.where(category: 'past week').first&.count,
      past_month: PageVisitGrouping.where(category: 'past month').first&.count,
      past_year: PageVisitGrouping.where(category: 'past year').first&.count
    }
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
