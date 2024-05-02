# frozen_string_literal: true

# TODO: Introduce pagination to the users and teams lists

# Controller for the admin page
class AdminController < ApplicationController
  include AdminHelper
  include MetricsHelper

  layout 'admin'
  before_action :check_access_rights

  ####################
  # GET

  def index
    # TODO: Implement sorting defaults, saved in the SiteAdmin table
    @users = User.all.includes(:site_admin)
    @visit_metrics = popularity_data
    @earliest = PageVisitGrouping.where(category: 'earliest')
                                 .first&.period_start || 1.day.ago

    @teams = Team.all
    @js_users = @users.to_json
    @js_roles = TeamRole.all.to_json
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
    # TODO: Implement sorting options
    response = get_fe_users User.all
    render json: response
  end

  # def update_user
  #   result = Admin::UpdateUserService.call params[:id], params[:name], params[:email], params[:is_admin]
  #   render json: result.to_json
  # end
  #
  # def new_user
  #   result = Admin::NewUserService.call params[:name], params[:email], params[:password], params[:site_admin]
  #   render json: result.to_json
  # end
  #
  # def remove_user
  #   user = User.find_by id: params[:id]
  #   user&.destroy
  # end

  # Updates the team manager of the corresponding team
  #
  # @param [Integer] team_id    The id of the team we want to change
  # @param [Integer] manager_id The id of the new manager
  def update_team_manager
    return if params[:manager_id].nil? || params[:team_id].nil?

    manager_id = Integer params[:manager_id], exception: false
    team_id = Integer params[:team_id], exception: false
    return if manager_id.nil? || team_id.nil?

    team = Team.find_by(id: team_id)
    team.owner_id = manager_id
    team.save
  end

  # Adds a new player to the corresponding team
  #
  # @param [Integer] team_id   The id of the team
  # @param [Integer] player_id The user id of the player
  def add_team_player
    return if params[:player_id].nil? || params[:team_id].nil?

    player_id = Integer params[:player_id], exception: false
    team_id = Integer params[:team_id], exception: false
    return if player_id.nil? || team_id.nil?

    UserTeam.create team_id: team_id, user_id: player_id
  end

  # Removes a player from a team
  #
  # @param [Integer] team_id   The id of the team
  # @param [Integer] player_id The user id of the player to remove
  def remove_team_player
    return if params[:player_id].nil? || params[:team_id].nil?

    player_id = Integer params[:player_id], exception: false
    team_id = Integer params[:team_id], exception: false
    return if player_id.nil? || team_id.nil?

    UserTeam.destroy_by team_id: team_id, user_id: player_id
  end
end
