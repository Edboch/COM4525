# frozen_string_literal: true

# Controller for managing user team relations in the application
class UserTeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_team, only: %i[new create destroy]
  before_action :set_user_team, only: %i[accept reject]

  def show; end

  def new
    @user_team = @team.user_teams.build
    authorize! :new, @user_team
  end

  def create
    @team = Team.find(params[:team_id])
    user = User.find_by(email: user_team_params[:email])
    return handle_no_user unless user

    if UserTeam.find_by(user_id: user.id, team_id: @team.id)
      handle_user_exist
    else
      create_user_team(user)
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

    team_role = TeamRole.find_or_create_by(name: 'regular', type: :regular)

    @user_team.roles << team_role unless @user_team.roles.include?(team_role)

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
    authorize! :create, @user_team

    return unless @user_team.save

    # Adding the following line to avoid Rubocop error 'Lint/Syntax: else without rescue is useless'
    if @user_team.save
      redirect_to dashboard_path, notice: I18n.t('userteam.create.success')
    else
      render :new, status: :unprocessable_entity
      # Adding the following line to avoid Rubocop error 'Lint/Syntax: unexpected token $end'
    end
  end

  def handle_no_user
    @user_team = @team.user_teams.build
    @user_team.errors.add(:email, 'No user found with this email')
    render :new, status: :unprocessable_entity
  end

  def handle_user_exist
    @user_team = @team.user_teams.build
    @user_team.errors.add(:email, 'User already exists in the team')
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
