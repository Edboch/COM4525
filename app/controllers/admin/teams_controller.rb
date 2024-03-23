# frozen_string_literal: true

class Admin::TeamsController < ApplicationController

  ###################
  ## POST

  def set_owner
    team = Team.find_by id: params[:team_id]
    user = User.find_by id: params[:user_id]
    if team.nil?
      render json: { success: false, message: "Unknown Team ID #{params[:team_id]}" }
      return
    end
    if user.nil?
      render json: { success: false, message: "Unknown User ID #{params[:user_id]}" }
      return
    end

    team.owner = user
    team.save
    render json: { success: true }
  end

  def add_member
    team = Team.find_by id: params[:team_id]
    if team.nil?
      render json: { success: false, message: "Unknown Team ID #{params[:team_id]}" }
      return
    end

    user = User.find_by id: params[:user_id]
    if user.nil?
      render json: { success: false, message: "Unknown User ID #{params[:user_id]}" }
      return
    end

    roles = TeamRole.where id: params[:role_ids].split(',')
    if roles.size == 0
      render json: { success: false, message: "Unknown Role IDs #{params[:role_ids]}" }
      return
    end

    UserTeam.create team: team, user: user, roles: roles
    render json: { success: true }
  end

  def remove_member
    to_remove = UserTeam.find_by id: params[:user_team_id]
    if to_remove.nil?
      json = {
        success: false,
        message: "Unknown Member/User Team ID #{params[:user_team_id]}"
      }
      render json: json
      return
    end

    to_remove.destroy
    render json: { success: true }
  end

  def update_member_roles
    to_update = UserTeam.find_by id: params[:user_team_id]
    if to_update.nil?
      json = {
        success: false,
        message: "Unknown Member/User Team ID #{params[:user_team_id]}"
      }
      render json: json
      return
    end

    roles = TeamRole.where id: params[:role_ids].split(',')
    if roles.size == 0
      render json: { success: false, message: "Unknown Role IDs #{params[:role_ids]}" }
      return
    end

    to_update.roles = roles
    render json: { success: true }
  end
end
