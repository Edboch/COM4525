# frozen_string_literal: true

# controller for managing matches in the application
class MatchesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_team, only: %i[create new show edit update fixtures]
  before_action :set_match, only: %i[show edit update destroy rate_players]

  # passed a team_id to display that teams matches
  def fixtures
    @matches = Match.where(team_id: @team.id).order(:start_time).page(params[:page]).per(6)
    @team = Team.find(@team.id)
  end

  # GET /matches/1
  def show
    @team = @match.team
    @match_decorator = @match.decorate

    if current_user.staff_of_team?(@team)
      user_teams = UserTeam.where(team_id: @team.id, accepted: true)
      @players = user_teams.map { |user_team| User.find_by(id: user_team.user_id) }
      @options = [['N/A', -1]]
      (0..10).each do |v|
        @options << [v, v]
      end
    else
      rating = current_user.player_ratings.find_by(match: @match)&.rating
      @rating = rating == -1 ? 'N/A' : rating || 'N/A'
    end
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
    @match.status = @match.get_status(@match.start_time)
    @match.team_id = @team.id

    if @match.save
      create_player_matches(@team, @match)
      redirect_to team_fixtures_path(@team.id), notice: I18n.t('match.create')
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /matches/1
  def update
    if @match.update(match_params)
      redirect_to team_fixtures_path(@team.id), notice: I18n.t('match.update'), status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # POST /matches/:id/rate_players
  def rate_players
    ActiveRecord::Base.transaction do
      params[:player_ratings].each do |user_id, rating|
        PlayerRating.find_or_initialize_by(match: @match, user_id: user_id).update!(rating: rating)
      end
    end
    redirect_to team_match_path(@match.team, @match), notice: I18n.t('teammatchratings.update')
  rescue ActiveRecord::RecordInvalid
    render :edit, status: :unprocessable_entity
  end

  # POST
  def submit_lineup
    ActiveRecord::Base.transaction do
      params[:player_matches].each do |player_match_id, attributes|
        player_match = PlayerMatch.find(player_match_id)
        pos_value = PlayerMatch.positions[attributes[:position]]
        player_match.update!(position: pos_value)
      end
    end
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

  def create_player_matches(team, match)
    team.users.each do |player|
      match.player_matches.create(user: player)
    end
  end

  def set_team
    @team = Team.find(params[:team_id])
  end

  def set_match
    @match = Match.find(params[:id])
  end

  # only allow a list of trusted parameters through.
  def match_params
    params.require(:match).permit(:location, :start_time, :opposition, :goals_for, :goals_against)
  end
end
