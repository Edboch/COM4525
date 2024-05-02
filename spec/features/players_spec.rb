# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Players' do
  let!(:player) { create(:user) }
  let!(:manager) { create(:user) }
  let!(:team) { create(:team, owner_id: manager.id) }

  before do
    create(:user_team, team_id: team.id, user_id: player.id, accepted: true)
    create(:match, team: team, opposition: 'Past Opposition', start_time: '2024-05-01 14:07:11 +0100')
    login_as(player, scope: :user)
    visit dashboard_path
    click_on 'View Team'
  end

  context 'when logged in as a player' do
    specify 'then i can view team fixtures' do
      click_on 'View Fixtures'
      expect(page).to have_content 'Here are your fixtures'
    end

    specify 'then i can view details of a match fixture' do
      click_on 'View Fixtures'
      expect(page).to have_content '2024-05-01 14:07:11 +0100'
    end
  end
end
