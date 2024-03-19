# # frozen_string_literal: true


# require 'rails_helper'

# RSpec.describe 'Inviting users' do
#   context 'when I am registered as a manager' do
#     let(:manager) { create(:user, :manager) } 
#     let(:player) { create(:user, :player) } 

#     before do
#       login_as manager
#       visit '/dashboard'
#     end

#     specify 'manager can create a team' do
#       click_on 'Create a new team'
#       fill_in 'team_name', with: 'Test Team'
#       fill_in 'team_location', with: 'Test Location'
#       click_on 'Create Team'
#       expect(page).to have_content 'Team details'
#     end

#     specify 'manager can invite a player' do
#       click_on 'Create a new team'
#       fill_in 'team_name', with: 'Test Team'
#       fill_in 'team_location', with: 'Test Location'
#       click_on 'Create Team'

#       visit "/teams/#{Team.last.id}/user_teams/new"
#       fill_in 'email', with: 'test@email.com'
#       click_on 'Invite Player'
#       expect(page).to have_content 'Invite was successfully sent.'
#     end

#   end
# end




# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Inviting users' do
  context 'when I am signed in as a manager' do
    let!(:manager) { FactoryBot.create(:user, :manager) }
    let!(:player) { FactoryBot.create(:user, :player) }
    let!(:team) { FactoryBot.create(:team) }
    let!(:user_team0) {FactoryBot.create(:user_team, user_id: 0, team_id: 0, accepted: true)}
    let!(:user_team1) {FactoryBot.create(:user_team, user_id: 1, team_id: 0, accepted: true)}

    before do
      login_as manager
      visit '/dashboard'
    end

    specify 'can invite a player' do
      expect(team.id).to eq 0

      visit "/teams/#{team.id}/user_teams/new"
      fill_in 'email', with: 'player@team.gg'
      click_on 'Invite Player'
      expect(page).to have_content 'Invite was successfully sent.'
    end

    specify 'cannot invite an unexist email' do
      expect(team.id).to eq 0

      visit "/teams/#{team.id}/user_teams/new"
      fill_in 'email', with: 'notplayer@team.gg'
      click_on 'Invite Player'
      expect(page).to have_content 'Email No user found with this email'
    end

    specify 'manager can see list of players' do
      expect(player.name).to eq 'Playername'

      visit "/teams/#{team.id}/players"
      expect(page).to have_content 'Joined'
      expect(page).to have_content 'Playername'
    end

    specify 'manager can remove a player account' do
      expect(player.name).to eq 'Playername'

      visit "/teams/#{team.id}/players"
      click_on 'Remove'
      # page.accept_alert
      expect(page).to have_content('Player removed from your team successfully.')
    end
  end


  context 'when I am signed in as a player' do
    let!(:manager) { FactoryBot.create(:user, :manager) }
    let!(:player) { FactoryBot.create(:user, :player) }
    let!(:team) { FactoryBot.create(:team) }
    let!(:user_team0) {FactoryBot.create(:user_team, user_id: 0, team_id: 0, accepted: false)}
    let!(:user_team1) {FactoryBot.create(:user_team, user_id: 1, team_id: 0, accepted: true)}

    before do
      login_as player
      visit '/dashboard'
    end

    specify 'can view a list of team invites' do
      visit "/player/invites"
      expect(page).to have_content('Invite from')
    end

    specify 'can accpet a team invitation' do
      visit "/player/invites"
      click_on 'Accept'
      expect(page).to have_content('Invite accepted.')
    end

    specify 'can accpet a team invitation' do
      visit "/player/invites"
      click_on 'Accept'
      expect(page).to have_content('Invite accepted.')
      # expect(user_team0.accepted).to eq true
    end

    specify 'can reject a team invitation' do
      visit "/player/invites"
      click_on 'Reject'
      expect(page).to have_content('Invite rejected.')
    end

  end

end
