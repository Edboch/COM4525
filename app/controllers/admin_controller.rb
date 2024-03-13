# frozen_string_literal: true

# Controller for the admin page
class AdminController < ApplicationController
  include MetricsHelper
  layout false
  before_action :check_access_rights

  ####################
  # GET

  def index
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
    players = []
    managers = []
    site_admins = []

    # TODO: Look into using CanCanCan abilities to resolve this
    User.select(:id, :name, :email).decorate.each do |user|
      if user.player?
        players.append({
                         id: user.id, name: user.name, email: user.email, roles: ['player']
                       })
      end
      if user.manager?
        managers.append({
                          id: user.id, name: user.name, email: user.email, roles: ['manager']
                        })
      end
      next unless user.site_admin?

      site_admins.append({
                           id: user.id, name: user.name, email: user.email, roles: ['site-admin']
                         })
    end

    response = { players: players, managers: managers, site_admins: site_admins }
    render json: response
  end

  def update_user
    user = User.find_by id: params[:id]
    return if user.nil?

    user.name = params[:name]
    user.email = params[:email]
    result = user.save
    render json: { success: result }
  end

  private

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
