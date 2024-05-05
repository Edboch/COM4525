# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Players' do
  let!(:player) { create(:user) }
  let!(:manager) { create(:user) }
  let!(:team) { create(:team, owner_id: manager.id) }

  before do
    create(:user_team, team_id: team.id, user_id: player.id, accepted: true)
    create(:match, team: team, start_time: '2024-05-01 14:07:11 +0100')
    login_as(player, scope: :user)
    visit dashboard_path
    click_on 'View Team'
  end

  context 'when logged in as a player' do
    before do
      click_on 'All Fixtures'
    end

    specify 'then i can view the opponent of a match' do
      expect(page).to have_content 'Some Opposition'
    end

    specify 'then i can view the date of a match fixture' do
      expect(page).to have_content 'Wednesday, May 1, 2024 02:07 PM'
    end

    specify 'then i can view the location of a match fixture' do
      expect(page).to have_content 'Some Location'
    end

    specify 'then i can view the score of a match fixture' do
      expect(page).to have_content '2-1 win'
    end
  end
end
