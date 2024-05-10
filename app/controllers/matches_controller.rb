# frozen_string_literal: true

# controller for managing matches in the application
class MatchesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_team, only: %i[create new show edit update postpone fixtures]
  before_action :set_match, only: %i[show edit update destroy rate_players]

  # passed a team_id to display that teams matches
  def fixtures
    @matches = Match.where(team_id: @team.id).order(:start_time).page(params[:page]).per(6).decorate
    @team = Team.find(@team.id)
  end

  # GET /matches/1
  def show
    @player_matches = ordered_player_matches
    @players, @options, @rating = player_ratings_data
  end

  # GET /matches/new
  def new
    @match = Match.new
  end

  # GET /matches/1/edit
  def edit; end

  # POST /matches
  def create
    @match = @team.matches.new(match_params).decorate
    @match.status = @match.display_status
    @match.team_id = @team.id

    if @match.save
      UserMailer.delay.create_match_email(UserTeam.where(team_id: @team.id, accepted: true).map do |user_team|
                                            User.find_by(id: user_team.user_id)
                                          end)
      create_player_matches(@team, @match)
      redirect_to team_fixtures_path(@team.id), notice: I18n.t('match.create')
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /matches/1
  def update
    if @match.update(match_params)
      UserMailer.delay.update_match_email(UserTeam.where(team_id: @team.id, accepted: true).map do |user_team|
                                            User.find_by(id: user_team.user_id)
                                          end)
      redirect_to team_fixtures_path(@team.id), notice: I18n.t('match.update'), status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /matches/1/postpone
  def postpone
    postpone_match_status('Postponed', 'match.postpone')
    UserMailer.delay.postpone_match_email(UserTeam.where(team_id: @team.id, accepted: true).map do |user_team|
      User.find_by(id: user_team.user_id)
    end)
  end

  # PATCH/PUT /matches/1/postpone
  def resume
    resume_match_status('Upcoming', 'match.resume')
    UserMailer.delay.resume_match_email(UserTeam.where(team_id: @team.id, accepted: true).map do |user_team|
      User.find_by(id: user_team.user_id)
    end)
  end

  # POST /matches/:id/rate_players
  def rate_players
    Matches::RatingsUpdater.new(@match, params[:player_ratings]).update_ratings
    redirect_to team_match_path(@match.team, @match), notice: I18n.t('teammatchratings.update')
  rescue ActiveRecord::RecordInvalid
    render :edit, status: :unprocessable_entity
  end

  # POST
  def submit_lineup
    Matches::LineupsUpdater.new(@match, params[:player_matches]).update_lineup
    redirect_to team_match_path(@match.team, @match), notice: I18n.t('lineup.success')
  rescue ActiveRecord::RecordInvalid
    render :show, status: :unprocessable_entity
  end

  # players toggle their availability for a match (updates the PlayerMatch object)
  def toggle_availability
    player_match = PlayerMatch.find_by(match_id: params[:match_id], user_id: params[:user_id])

    if player_match&.update(available: !player_match.available)
      redirect_back(fallback_location: team_match_path(player_match.match.team, player_match.match),
                    notice: I18n.t('availability.success'))
    else
      redirect_back(fallback_location: team_match_path(player_match.match.team, player_match.match),
                    alert: I18n.t('availability.fail'))
    end
  end

  # DELETE /matches/1
  def destroy
    @match.destroy
    redirect_to team_fixtures_path(@match.team), notice: I18n.t('match.destroy')
  end

  private

  def update_match_status(status, message)
    if @match.update(status: status)
      redirect_to team_match_path(@match.team, @match), notice: I18n.t(message)
    else
      render :show, status: :unprocessable_entity
    end
  end

  def ordered_player_matches
    # sort the player_matches by their position to display appropriately
    @match.player_matches.sort_by { |player_match| PlayerMatch.positions[player_match.position] }
  end

  def player_ratings_data
    Matches::RatingData.new(@team, current_user, @match).data
  end

  def create_player_matches(team, match)
    team.users.each do |player|
      match.player_matches.create(user: player, position: 5)
    end
  end

  def set_team
    @team = Team.find(params[:team_id])
  end

  def set_match
    @match = Match.find(params[:id]).decorate
  end

  # only allow a list of trusted parameters through.
  def match_params
    params.require(:match).permit(:location, :start_time, :opposition, :goals_for, :goals_against)
  end
end
