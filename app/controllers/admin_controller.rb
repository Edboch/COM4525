# frozen_string_literal: true

# Controller for the admin page
class AdminController < ApplicationController
  layout false
  before_action :check_access_rights

  ####################
  # GET

  def index
    @visit_metrics = retrieve_popularity_metrics
  end

  ############
  # POST

  def retrieve_popularity_metrics
    render json: retrieve_popularity_metrics
  end

  def retrieve_users
    # Target Query
    # SELECT users.id, users.email, users.type,
    #     CASE
    #       WHEN site_admins.user_id = users.id THEN true
    #       ELSE false
    #     END AS is_admin
    # FROM users
    # FULL JOIN site_admins ON users.id=site_admins.user_id;

    # The idea is that a user will only be assigned to the array of their
    # highest role
    # The arrays below are in ascending order
    players = []
    managers = []
    site_admins = []

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
      avgw: PageVisitGrouping.where(category: 'avg week').first.count,
      avgm: PageVisitGrouping.where(category: 'avg month').first.count,
      avgy: PageVisitGrouping.where(category: 'avg year').first.count,
      pastw: PageVisitGrouping.where(category: 'past week').first.count,
      pastm: PageVisitGrouping.where(category: 'past month').first.count,
      pasty: PageVisitGrouping.where(category: 'past year').first.count
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
