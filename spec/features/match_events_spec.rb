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

  before do
    create(:user_team, user: player, team: team, accepted: true)
    create(:user_team, user: another_player, team: team, accepted: true)
    team.owner_id = manager.id
    team.save
    another_team.owner_id = another_manager.id
    another_team.save
  end

  context 'when user is the manager' do
    before do
      login_as(manager, scope: :user)
      visit team_match_path(team, match)
    end

    it 'allows manager to add match event for their team' do
      select player.name, from: 'Player'
      select 'Goal', from: 'Event Type'
      fill_in 'Event Minute', with: '33'

      expect { click_on('Add Event') }.to change(MatchEvent, :count).by(1)
    end

    it 'does not add a match event where fields are missing' do
      # omit minute field
      select player.name, from: 'Player'
      select 'Goal', from: 'Event Type'

      expect { click_on('Add Event') }.not_to change(MatchEvent, :count)
    end

    it 'allows manager to delete a match event for their team' do
      create(:match_event, match: match, user: player, event_type: 'goal')
      visit current_path

      expect { click_on 'Delete' }.to change(MatchEvent, :count).by(-1)
    end

    it 'allows manager to view match events for their team' do
      create(:match_event, match: match, user: player, event_type: 'goal', event_minute: 33)
      visit current_path

      expect(page).to have_content('Goal: Minute 33') & have_content("Player: #{player.name}")
    end

    it 'allows manager to view player summary page' do
      visit player_stats_team_path(team, player)
      expect(page).to have_content("#{player.name}'s Overall Stats for #{team.name}")
    end

    it 'does not allow manager to view player summary page for another team' do
      create(:user_team, user: player, team: another_team, accepted: true)
      visit player_stats_team_path(another_team, player)

      expect(page).to have_content('You are not authorized to access this page.')
    end
  end

  context 'when user is the player' do
    before do
      login_as(player, scope: :user)
      visit team_match_path(team, match)
    end

    it 'allows player to view match event' do
      create(:match_event, match: match, user: player, event_type: 'goal', event_minute: 33)
      visit current_path

      expect(page).to have_content('Goal: Minute 33') & have_content("Player: #{player.name}")
    end

    it 'allows player to view their own player page within their team' do
      visit player_stats_team_path(team, player)

      expect(page).to have_content("#{player.name}'s Overall Stats for #{team.name}")
    end

    it 'allows player to view player page for others in the team' do
      visit player_stats_team_path(team, another_player)

      expect(page).to have_content("#{another_player.name}'s Overall Stats for #{team.name}")
    end

    it 'does not allow player to view player page for someone in another team' do
      create(:user_team, user: another_player, team: another_team, accepted: true)
      visit player_stats_team_path(another_team, another_player)

      expect(page).to have_content('You are not authorized to access this page.')
    end
  end
end
