# frozen_string_literal: true

# Controller for Matches
class MatchesController < ApplicationController
  before_action :set_match, only: %i[show edit update destroy]

  # passed @team to display that teams matches
  def fixtures
    @matches = Match.where(team_id: params[:team_id])
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
    @match = Match.new(match_params)

    if @match.save
      redirect_to @match, notice: I82n.t('match.create')
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /matches/1
  def update
    if @match.update(match_params)
      redirect_to @match, notice: I82n.t('match.update'), status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /matches/1
  def destroy
    @match.destroy
    redirect_to matches_url, notice: I82n.t('match.destroy'), status: :see_other
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_match
    @match = Match.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def match_params
    params.fetch(:match, {})
  end
end
