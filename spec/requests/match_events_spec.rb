# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe 'match events' do
  let!(:manager) { create(:user) }
  let!(:another_manager) { create(:user) }
  let!(:team) { create(:team) }
  let!(:another_team) { create(:team) }
  let!(:player) { create(:user) }
  let!(:another_player) { create(:user) }
  let!(:match) { create(:match, team: team) }
  let!(:another_match) { create(:match, team: another_team) }
  let!(:event_params) do
    {
      match_event: {
        user_id: player,
        event_type: 'goal',
        event_minute: 33
      }
    }
  end

  before do
    create(:user_team, user: player, team: team, accepted: true)
    create(:user_team, user: another_player, team: team, accepted: true)
    create(:user_team, user: player, team: another_team, accepted: true)
    team.owner_id = manager.id
    team.save
    another_team.owner_id = another_manager.id
    another_team.save
  end

  context 'when user is the manager' do
    before do
      login_as(manager, scope: :user)
    end

    it 'does not allow manager to add match event for another team' do
      expect do
        post team_match_match_events_path(another_match.team, another_match), params: event_params
      end.not_to change(MatchEvent, :count)
    end

    it 'does not allow manager to delete a match event for another team' do
      match_event = create(:match_event, match: another_match, user: player, event_type: 'goal', event_minute: 33)
      expect do
        delete team_match_match_event_path(another_match.team, another_match, match_event)
      end.not_to change(MatchEvent, :count)
    end
  end

  context 'when user is the player' do
    before do
      login_as(player, scope: :user)
    end

    it 'does not allow player to add match event' do
      expect do
        post team_match_match_events_path(match.team, match), params: event_params
      end.not_to change(MatchEvent, :count)
    end

    it 'does not allow player to delete match event' do
      match_event = create(:match_event, match: match, user: player, event_type: 'goal', event_minute: 33)
      expect do
        delete team_match_match_event_path(team.id, match.id, match_event.id)
      end.not_to change(MatchEvent, :count)
    end
  end
end
