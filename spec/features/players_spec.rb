# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Players' do
  let!(:player) { create(:user) }
  let!(:manager) { create(:user) }
  let!(:team) { create(:team, owner_id: manager.id) }
  let!(:other_team) { create(:team, owner_id: manager.id) }
  let!(:match) { create(:match, team: team, start_time: '2024-05-01 14:07:11 +0100') }
  let!(:match_invite) { create(:invite, team: team) }

  before do
    create(:user_team, team_id: team.id, user_id: player.id, accepted: true)
    login_as(player, scope: :user)
    visit dashboard_path
  end

  context 'when viewing fixtures as a player' do
    before do
      click_on 'View Team'
      click_on 'All Fixtures'
    end

    specify 'then i can view the opponent of a match' do
      expect(page).to have_content 'Some Opposition'
    end

    # TODO: fix after UI changes
    specify 'then i can view the date of a match fixture' do
      expect(page).to have_content 'Wednesday, May 1, 2024 02:07 PM'
    end

    specify 'then i can view the location of a match fixture' do
      expect(page).to have_content 'Some Location'
    end

    # TODO: fix after UI changes
    specify 'then i can view the score of a match fixture' do
      expect(page).to have_content '2-1 win'
    end
  end

  # tests for access rights of a player belonging to a team they do not own
  context 'when logged in as a player' do
    specify 'then i cannot add fixtures to team' do
      visit new_team_match_path(team.id)
      expect(page).to have_content 'You are not authorized to access this page.'
    end

    specify 'then i cannot edit a fixture from my team' do
      visit edit_team_match_path(team.id, match.id)
      expect(page).to have_content 'You are not authorized to access this page.'
    end

    specify 'then i cannot delete a fixture from my team' do
      visit team_fixtures_path(team.id)
      expect(page).to have_no_content 'Delete'
    end

    specify 'then i cannot invite other players to team' do
      visit new_team_user_team_path(team.id)
      expect(page).to have_content 'You are not authorized to access this page.'
    end

    specify 'then i cannot delete other players in my team' do
      visit team_players_path(team.id)
      expect(page).to have_no_content 'Delete'
    end

    specify 'then i cannot invite other teams to a match' do
      visit new_team_invite_path(team.id)
      expect(page).to have_content 'You are not authorized to access this page.'
    end

    specify 'then i cannot edit invites to other teams' do
      visit edit_team_invite_path(team.id, match_invite.id)
      expect(page).to have_content 'You are not authorized to access this page.'
    end

    specify 'then i cannot view invites to other teams' do
      visit team_published_invites_path(team.id)
      expect(page).to have_content 'You are not authorized to access this page.'
    end

    specify 'then i cannot view a specific invite to other teams' do
      visit team_invite_path(team.id, match_invite.id)
      expect(page).to have_content 'You are not authorized to access this page.'
    end

    specify 'then i cannot edit team details' do
      visit edit_team_path(team.id)
      expect(page).to have_content 'You are not authorized to access this page.'
    end

    specify 'then i cannot delete my team' do
      visit team_path(team.id)
      expect(page).to have_no_content 'Delete Team'
    end

    specify 'then i cannot view another team dashboard' do
      visit team_path(other_team.id)
      expect(page).to have_content 'You are not authorized to access this page.'
    end
  end
end
