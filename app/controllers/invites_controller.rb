# frozen_string_literal: true

# Controller for invites
class InvitesController < ApplicationController
  before_action :set_team, only: %i[create new show edit update]
  before_action :set_invite, only: %i[show edit update destroy]

  # GET /invites
  def published_invites
    # @invites = Invite.all
    @invites = Invite.where(team_id: set_team.id)
    # @team = Team.find(@team.id)
  end

  # GET /invites/1
  def show; end

  # GET /invites/new
  def new
    @invite = Invite.new
  end

  # GET /invites/1/edit
  def edit; end

  # POST /invites
  def create
    @invite = @team.invites.new(invite_params)
    @invite.team_id = @team.id
    # @invite = Invite.new(invite_params)
    if @invite.save
      redirect_to team_published_invites_path(@team), notice: I18n.t('Invite was successfully created.')
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /invites/1
  def update
    if @invite.update(invite_params)
      redirect_to team_published_invites_path(@team), notice: I18n.t('Invite was successfully updated.'),
                                                      status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /invites/1
  def destroy
    team_id = @invite.team_id
    @invite.destroy
    redirect_to team_published_invites_path(team_id), notice: I18n.t('Invite was successfully destroyed.'),
                                                      status: :see_other
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_team
    @team = Team.find(params[:team_id])
  end

  def set_invite
    @invite = Invite.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def invite_params
    params.require(:invite).permit(:team_id, :time, :location, :description)
  end
end
