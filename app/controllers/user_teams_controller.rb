# frozen_string_literal: true

# Controller for managing user team relations in the application
class UserTeamsController < ApplicationController
  before_action :set_team, only: %i[new create destroy]
  before_action :set_user_team, only: %i[accept reject]

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

  # takes both a team id player id as a parameter
  def destroy
    user_team = UserTeam.find_by(team_id: params[:team_id], user_id: params[:user_id])

    user_team.destroy
    redirect_to team_players_path(@team), notice: I18n.t('team.players.remove')
  end

  def accept
    @user_team.update(accepted: true)
    redirect_to dashboard_path, notice: I18n.t('userteam.respond.accept')
  end

  # a user rejects the invitation, which destroys the db record
  def reject
    @user_team.destroy
    redirect_to dashboard_path, notice: I18n.t('userteam.respond.reject')
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
    # @user_team = @team.user_teams.build
    # @user_team.errors.add(:email, 'No user found with this email')
    render :new, status: :unprocessable_entity
  end

  def set_team
    @team = Team.find(params[:team_id])
  end

  def set_user_team
    @user_team = UserTeam.find(params[:id])
  end

  def user_team_params
    params.require(:user_team).permit(:team_id, :email)
  end
end
