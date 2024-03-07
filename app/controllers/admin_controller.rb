# frozen_string_literal: true

# Controller for the admin page
class AdminController < ApplicationController
  include MetricsHelper
  layout false
  before_action :check_access_rights

  ####################
  # GET

  def index
    @visit_metrics = retrieve_popularity_metrics
    @earliest = PageVisitGrouping.where(category: 'earliest').first&.period_start
    @earliest = Time.current - 1.day unless @earliest
  end

  ############
  # POST

  def retrieve_popularity_metrics
    render json: retrieve_popularity_metrics
  end

  def retrieve_popularity_range
    if params[:start].nil? || params[:end].nil? || params[:time_zone].nil?
      render body: '', status: :unprocessible_entity
      return
    end

    start_time = get_timezone_time params[:time_zone], params[:start].to_i
    end_time = get_timezone_time params[:time_zone], params[:end].to_i

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

  def retrieve_popularity_metrics
    {
      total: PageVisit.count,
      avgw: PageVisitGrouping.where(category: 'avg week').first&.count,
      avgm: PageVisitGrouping.where(category: 'avg month').first&.count,
      avgy: PageVisitGrouping.where(category: 'avg year').first&.count,
      pastw: PageVisitGrouping.where(category: 'past week').first&.count,
      pastm: PageVisitGrouping.where(category: 'past month').first&.count,
      pasty: PageVisitGrouping.where(category: 'past year').first&.count
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
