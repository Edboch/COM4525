# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Managing users' do
  let!(:regular) { create(:user) }
  let!(:manager) { create(:user) }
  let!(:team) { create(:team, owner_id: manager.id) }
  let!(:match) { create(:match, team: team, start_time: '2024-05-01 14:07:11 +0100') }
  let!(:match_invite) { create(:invite, team: team) }

  context 'when I am not a registered user' do
    before do
      visit dashboard_path
    end

    specify 'then I will be redirected to the login page' do
      expect(page).to have_content 'Login'
    end

    context 'when the registration form is correctly filled' do
      before do
        click_on 'Register'
      end

      specify 'I can create a new account' do
        fill_in 'Email', with: 'john_smith@outlook.com'
        fill_in 'Name', with: 'John'
        fill_in 'Password', with: 'Password'
        fill_in 'Password confirmation', with: 'Password'
        click_on 'Sign up'
        expect(page).to have_content 'Welcome! You have signed up successfully.'
      end
    end

    context 'when the registration form is filled incorrectly' do
      before do
        click_on 'Register'
      end

      specify 'with missing cells' do
        fill_in 'Email', with: 'john_smith@outlook.com'
        fill_in 'Name', with: 'John'
        click_on 'Sign up'
        expect(page).to have_content 'Please review the problems below:'
      end

      specify 'with an existing email' do
        fill_in 'Email', with: regular.email
        fill_in 'Name', with: 'John'
        fill_in 'Password', with: 'Password'
        fill_in 'Password confirmation', with: 'Password'
        click_on 'Sign up'
        expect(page).to have_content 'Email has already been taken'
      end

      specify 'with a different password confirmation' do
        fill_in 'Email', with: 'john_smith@outlook.com'
        fill_in 'Name', with: 'John'
        fill_in 'Password', with: 'Password'
        fill_in 'Password confirmation', with: 'Different'
        click_on 'Sign up'
        expect(page).to have_content "Password confirmation doesn't match Password"
      end
    end
  end

  context 'when i am a unregistered user' do
    specify 'then i cannot add fixtures to a team' do
      visit new_team_match_path(team.id)
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end

    specify 'then i cannot edit a fixture from a team' do
      visit edit_team_match_path(team.id, match.id)
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end

    specify 'then i cannot delete a fixture from a team' do
      visit team_fixtures_path(team.id)
      expect(page).to have_no_content 'Delete'
    end

    specify 'then i cannot invite players to a team' do
      visit new_team_user_team_path(team.id)
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end

    specify 'then i cannot delete players from a team' do
      visit team_players_path(team.id)
      expect(page).to have_no_content 'Delete'
    end

    specify 'then i cannot invite other teams to a match' do
      visit new_team_invite_path(team.id)
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end

    specify 'then i cannot edit invites to other teams' do
      visit edit_team_invite_path(team.id, match_invite.id)
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end

    specify 'then i cannot view invites to other teams' do
      visit team_published_invites_path(team.id)
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end

    specify 'then i cannot view a specific invite to other teams' do
      visit team_invite_path(team.id, match_invite.id)
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end

    specify 'then i cannot edit team details' do
      visit edit_team_path(team.id)
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end

    specify 'then i cannot view another team dashboard' do
      visit team_path(team.id)
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end

    specify 'then i cannot view invites to join teams' do
      visit player_invites_path
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end

    specify 'then i cannot view upcoming matches page' do
      visit player_upcoming_matches_path
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end

    specify 'then i cannot go to create a team page' do
      visit create_team_path
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end

    specify 'then i cannot go to profile page' do
      visit user_profile_path
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end

    specify 'then i cannot go to edit profile page' do
      visit edit_user_profile_path
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end

  context 'when I am a registered user' do
    before { visit '/' }

    specify 'then i can log into my account' do
      user = create(:user)
      fill_in 'Email', with: user.email
      fill_in 'Password', with: 'password'
      click_on 'Log in'
      expect(page).to have_content 'Signed in successfully.'
    end
  end

  context 'when i am logged into my account' do
    let!(:user1) do
      create(:user, email: 'test@email.com', password: 'Password')
    end

    before do
      login_as(user1, scope: :user)
      visit dashboard_path
    end

    specify 'then i can delete my account' do
      click_on 'My Profile'
      click_on 'Delete account'
      expect(page).to have_content 'Your account has been successfully deleted.'
    end

    specify 'then i can edit my name and email' do
      click_on 'My Profile'
      click_on 'Edit Profile'
      fill_in 'Email', with: 'edited@email.com'
      fill_in 'Name', with: 'editedname'
      click_on 'Update'
      expect(page).to have_content 'Profile was successfully updated.'
    end
  end
end
