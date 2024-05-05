# frozen_string_literal: true

# controller to control creation and deletion of match events
class MatchEventsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource :match
  load_and_authorize_resource :match_event, through: :match
  before_action :set_match

  # POST /teams/:team_id/matches/:match_id/match_events
  def create
    @match_event = @match.match_events.new(match_event_params)
    if @match_event.save
      redirect_to team_match_path(@match.team, @match), notice: I18n.t('matchevent.create')
    else
      redirect_to team_match_path(@match.team, @match), alert: I18n.t('matchevent.unsuccessful')
    end
  end

  # DELETE /teams/:team_id/matches/:match_id/match_events/:id
  def destroy
    @match_event = @match.match_events.find(params[:id])
    if @match_event.destroy
      redirect_to team_match_path(@match.team, @match), notice: I18n.t('matchevent.destroy')
    else
      redirect_to team_match_path(@match.team, @match), alert: I18n.t('matchevent.unsuccessfuldestroy')
    end
  end

  private

  def set_match
    @match = Match.find(params[:match_id])
  end

  def match_event_params
    params.require(:match_event).permit(:user_id, :event_type, :event_minute)
  end
end
