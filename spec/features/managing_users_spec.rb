# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Managing users' do
  context 'when I am not a registered user' do
    before do
      visit dashboard_path
    end

    specify 'then I will be redirected to the login page' do
      expect(page).to have_content 'Login'
    end

    specify 'then I can make an account as a player' do
      click_on 'Register'
      fill_in 'Email', with: 'john_smith@outlook.com'
      fill_in 'Name', with: 'John'
      fill_in 'Password', with: 'Password'
      fill_in 'Password confirmation', with: 'Password'
      click_on 'Sign up'
      expect(page).to have_content 'Welcome! You have signed up successfully.'
    end
  end

  context 'when I am a registered user' do
    before { visit '/' }

    specify 'then i can log into my account' do
      create(:user, email: 'test@email.com', password: 'Password')
      fill_in 'Email', with: 'test@email.com'
      fill_in 'Password', with: 'Password'
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
