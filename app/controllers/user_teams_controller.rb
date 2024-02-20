# frozen_string_literal: true

# Controller for managing user team relations in the application
class UserTeamsController < ApplicationController
  before_action :set_team

  def show; end

  def new
    @user_team = @team.user_teams.build
  end

  def create
    @team = Team.find(params[:team_id])
    user = User.find_by(email: user_team_params[:email])

    if user
      create_user_team(user)
    else
      handle_no_user
    end
  end

  private

  def create_user_team(user)
    @user_team = @team.user_teams.build(user_id: user.id)

    if @user_team.save
      redirect_to dashboard_path, notice: I18n.t('userteam.create.success')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def handle_no_user
    @user_team = @team.user_teams.build
    @user_team.errors.add(:email, 'No user found with this email')
    render :new, status: :unprocessable_entity
  end

  def set_team
    @team = Team.find(params[:team_id])
  end

  def user_team_params
    params.require(:user_team).permit(:team_id, :email)
  end
end
