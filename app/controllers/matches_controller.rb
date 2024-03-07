# frozen_string_literal: true

# Controller for Matches
class MatchesController < ApplicationController
  before_action :set_team, only: %i[create new show edit]
  before_action :set_match, only: %i[show edit update destroy]

  # passed a team_id to display that teams matches
  def fixtures
    @matches = Match.where(team_id: params[:team_id]).order(:start_time)
  end

  # GET /matches/1
  def show; end

  # GET /matches/new
  def new
    @match = Match.new
  end

  # GET /matches/1/edit
  def edit; end

  # POST /matches
  def create
    @match = @team.matches.new(match_params)
    @match.status = get_status(@match.start_time)
    @match.team_id = @team.id

    if @match.save
      redirect_to team_fixtures_path(@team.id), notice: I18n.t('match.create')
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /matches/1
  def update
    if @match.update(match_params)
      redirect_to @match, notice: I18n.t('match.update'), status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /matches/1
  def destroy
    @match.destroy
    redirect_to matches_url, notice: I18n.t('match.destroy'), status: :see_other
  end

  private

  def get_status(start_time)
    if start_time < Time.current
      'Completed'
    else
      'Upcoming'
    end
  end

  def set_team
    @team = Team.find(params[:team_id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_match
    @match = Match.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def match_params
    params.require(:match).permit(:location, :start_time, :opposition)
  end
end
