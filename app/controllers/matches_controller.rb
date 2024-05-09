# frozen_string_literal: true

# controller for managing creating and editing a team's Matches
# in the application
class MatchesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_team, only: %i[create new show edit update cancel postpone fixtures]
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

    if current_user.staff_of_team?(@team, current_user)
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
    @match = @team.matches.new(match_params)
    @match.status = get_status(@match.start_time)
    @match.team_id = @team.id

    if @match.save
      UserMailer.create_match_email(UserTeam.where(team_id: @team.id, accepted: true).map { |user_team| User.find_by(id: user_team.user_id) }).deliver
      redirect_to team_fixtures_path(@team.id), notice: I18n.t('match.create')
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /matches/1
  def update
    if @match.update(match_params)
      @match.update(status: 'Upcoming')
      redirect_to team_fixtures_path(@team.id), notice: I18n.t('match.update'), status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /matches/1/cancel
  def cancel
    @match.update(status: 'Cancelled')
    redirect_to team_fixtures_path(@team.id), notice: I18n.t('match.cancel')
  end

  # PATCH/PUT /matches/1/postpone
  def postpone
    @match.update(status: 'Postponed')
    redirect_to team_fixtures_path(@team.id), notice: I18n.t('match.postpone')
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

  # DELETE /matches/1
  def destroy
    @match.destroy
    redirect_to team_fixtures_path(@match.team), notice: I18n.t('match.destroy')
  end

  private

  def match_event_params
    params.require(:match_event).permit(:user_id, :event_type, :event_minute)
  end

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

  def set_match
    @match = Match.find(params[:id])
  end

  # only allow a list of trusted parameters through.
  def match_params
    params.require(:match).permit(:location, :start_time, :opposition, :goals_for, :goals_against)
  end
end
