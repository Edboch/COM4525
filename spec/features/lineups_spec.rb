# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe 'lineups', :js do
  let!(:manager) { create(:user) }
  let!(:team) { create(:team, owner_id: manager.id) }
  let!(:player) { create(:user) }
  let!(:match) { create(:match, team: team) }
  let!(:tr_player) { create(:team_role, :player) }
  let!(:ut_player) { create(:user_team, user: player, team: team, accepted: true) }

  before do
    create(:player_match, match_id: match.id, user_id: player.id)
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
  end
end
