# frozen_string_literal: true

# Controller for managing teams in the application
class TeamsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_team, only: %i[show edit update destroy players league sync_fixtures create_fixtures player_stats]

  # GET /teams
  def index
    @teams = Team.all
  end

  # GET /teams/:id/sync_fixtures
  def sync_fixtures
    scraper = Scrapers::ScraperFactory.create_scraper(@team.url, @team.team_name)
    @fixtures = scraper.fetch_fixtures + scraper.fetch_results
  end

  # POST /teams/:id/sync_fixtures
  def create_fixtures
    params[:fixtures].each do |fixture|
      next unless fixture[:selected] == '1'

      @team.matches.create(
        location: fixture[:location],
        start_time: Time.zone.parse(fixture[:start_time]),
        opposition: fixture[:opposition],
        goals_for: fixture[:goals_for],
        goals_against: fixture[:goals_against],
        status: fixture[:goals_for].nil? ? 'Upcoming' : 'Completed'
      )
    end
    redirect_to team_fixtures_path(@team), notice: t('team.sync_success')
  end

  # GET /teams/1
  def show; end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # GET /teams/1/edit
  def edit; end

  # POST /teams
  def create
    @team = Team.new(team_params)

    if @team.save
      redirect_to @team, notice: I18n.t('team.create.success')
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /teams/1
  def update
    if @team.update(team_params)
      redirect_to @team, notice: I18n.t('team.update.success'), status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /teams/1
  def destroy
    @team.destroy
    redirect_to dashboard_path, notice: I18n.t('team.destroy.success'), status: :see_other
  end

  def players
    # fetch all userteams with this team id and accepted invite
    user_teams = UserTeam.where(team_id: @team.id)

    # fetch all players with userteams user id
    @players = user_teams.map do |user_team|
      User.find_by(id: user_team.user_id).decorate
    end.compact
  end

  def league
    @league = Scrapers::ScraperFactory.create_scraper(@team.url, @team.team_name).fetch_league
  rescue StandardError
    @league = nil
  end

  # GET /teams/:id/player/:user_id
  def player_stats
    @player = User.find(params[:user_id])
  end

  private

  def set_team
    @team = Team.find(params[:id]).decorate
    @matches = @team.matches
                    .where('start_time > ?', Time.current)
                    .order(:start_time)
    @invites = @team.invites.where('time > ?', Time.current).order(:time)
  end

  # Only allow a list of trusted parameters through.
  def team_params
    params.require(:team).permit(:name, :location_name, :owner_id, :url, :team_name)
  end
end
