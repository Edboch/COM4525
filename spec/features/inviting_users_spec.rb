# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Inviting users' do
  context 'when I am signed in as a manager' do
    let!(:manager) { create(:user, :manager) }
    let!(:team) { create(:team) }

    before do
      create(:user, :player)
      create(:user, email: 'newplayer@team.gg', id: 3)
      create(:user_team, user_id: 0, team_id: 0, accepted: true)
      create(:user_team, user_id: 1, team_id: 0, accepted: true)

      login_as manager
      visit '/dashboard'
    end

    specify 'can invite a player' do
      visit "/teams/#{team.id}/user_teams/new"
      fill_in 'email', with: 'newplayer@team.gg'
      click_on 'Invite Player'
      expect(page).to have_content 'Invite was successfully sent.'
    end

    specify 'cannot invite an email that doesnt exist' do
      visit "/teams/#{team.id}/user_teams/new"
      fill_in 'email', with: 'notplayer@team.gg'
      click_on 'Invite Player'
      expect(page).to have_content 'Email No user found with this email'
    end

    specify 'cannot invite a player that exists in team' do
      visit "/teams/#{team.id}/user_teams/new"
      fill_in 'email', with: 'player@team.gg'
      click_on 'Invite Player'
      expect(page).to have_content 'Email User already exists in the team'
    end

    specify 'manager can see list of players' do
      visit "/teams/#{team.id}/players"
      expect(page).to have_content 'Playername'
    end

    specify 'manager can remove a player account' do
      visit "/teams/#{team.id}/players"
      click_on 'Remove'
      # page.accept_alert
      expect(page).to have_content('Player removed from your team successfully.')
    end
  end

  context 'when I am signed in as a player' do
    let!(:player) { create(:user, :player) }

    before do
      create(:user, :manager)
      create(:team)
      create(:user_team, user_id: 0, team_id: 0, accepted: false)
      create(:user_team, user_id: 1, team_id: 0, accepted: true)
      login_as player
      visit '/dashboard'
    end

    specify 'can view a list of team invites' do
      visit '/player/invites'
      expect(page).to have_content('Invite from')
    end

    specify 'can accpet a team invitation' do
      visit '/player/invites'
      click_on 'Accept'
      expect(page).to have_content('Invite accepted.')
    end

    specify 'can reject a team invitation' do
      visit '/player/invites'
      click_on 'Reject'
      expect(page).to have_content('Invite rejected.')
    end
  end
end
