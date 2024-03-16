# frozen_string_literal: true

# Controller for the admin page
class AdminController < ApplicationController
  layout false
  before_action :check_access_rights

  ####################
  # GET

  def index
    @teams = user_teams
    raw = User.includes(:roles)
              .where(roles: { name: 'Manager' })
              .pluck(:id, :name, :email)
              .map { |m| { id: m[0], name: m[1], email: m[2] } }

    as_strings = raw.map do |m|
        "{ id: #{m[:id]}, name: '#{m[:name]}', email: '#{m[:email]}' }"
      end
    @js_managers = "[ #{as_strings.join(', ')} ]"


    raw = User.includes(:roles)
              .where(roles: { name: 'Player' })
              .pluck(:id, :name, :email)
              .map { |p| { id: p[0], name: p[1], email: p[2] } }

    as_strings = raw.map do |p|
        "{ id: #{p[:id]}, name: '#{p[:name]}', email: '#{p[:email]}' }"
      end
    @js_players = "[ #{as_strings.join(', ')} ]"
  end

  ############
  # POST

  def retrieve_popularity_metrics
    response = { total: PageVisit.count, avgm: 0, avgw: 0 }
    render json: response
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

  def remove_user
    user = User.find_by id: params[:id]
    return if user.nil?

    user.name = params[:name]
    user.email = params[:email]
    user.destroy
  end

  def update_team_manager
    return if params[:manager_id].nil? || params[:team_id].nil?

    manager_id = Integer params[:manager_id], exception: false
    team_id = Integer params[:team_id], exception: false
    return if manager_id.nil? || team_id.nil?

    team = Team.find_by(id: team_id)
    team.owner_id = manager_id
    team.save
  end

  private

  def user_teams
    Team.select(:id, :name, :location_name, :owner_id)
        .includes(:users)
        .map do |team|
          manager = User.find_by(id: team.owner_id)
          players = team.users.pluck(:id, :name)
                        .map { |u| { id: u[0], name: u[1] } }

          {
            id: team.id, name: team.name,
            location: { name: team.location_name },
            manager: { id: manager&.id, name: manager&.name },
            players: players
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
