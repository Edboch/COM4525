# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe 'lineups' do
  let!(:manager) { create(:user) }
  let!(:team) { create(:team, owner_id: manager.id) }
  let!(:player) { create(:user) }
  let!(:match) { create(:match, team: team) }
  let!(:tr_player) { create(:team_role, :player) }
  let!(:ut_player) { create(:user_team, user: player, team: team, accepted: true) }

  before do
    create(:player_match, match_id: match.id, user_id: player.id, position: 5) # default 'reserve' position added
    ut_player.roles << tr_player
  end

  context 'when logged in as a player' do
    before do
      login_as(player, scope: :user)
      visit team_path(team.id)
    end

    specify 'then i can log my availability for a match' do
      click_on 'All Fixtures'
      find_by_id('availability').click
      player_match = PlayerMatch.find_by user_id: player.id, match_id: match.id
      expect(player_match.available).to be true
    end

    specify 'then i can edit availability for a match' do
      click_on 'All Fixtures'
      find_by_id('availability').click
      find_by_id('availability').click
      player_match = PlayerMatch.find_by user_id: player.id, match_id: match.id
      expect(player_match.available).to be false
    end

    specify 'then i can view my position for the upcoming game' do
      click_on 'All Fixtures'
      click_on 'View'
      expect(page).to have_content 'Reserve'
    end
  end

  context 'when logged in as a manager' do
    before do
      login_as(manager, scope: :user)
      visit team_path(team.id)
    end

    specify 'then i can see the player availability' do
      click_on 'All Fixtures'
      click_on 'View'
      expect(page).to have_content 'No'
    end

    specify 'then i can give a position for a player for the next match' do
      click_on 'All Fixtures'
      click_on 'View'
      player_match = PlayerMatch.find_by user_id: player.id, match_id: match.id
      select 'Goalkeeper', from: "player_matches_#{player_match.id}_position"
      click_on 'Submit Lineup'
      expect(player_match.reload.position).to eq 'Goalkeeper'
    end
  end
end
