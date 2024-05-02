# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Managing users' do
  let!(:regular) { create(:user) }

  context 'when I am not a registered user' do
    before do
      visit dashboard_path
    end

    specify 'then I will be redirected to the login page' do
      expect(page).to have_content 'Login'
    end

    context 'when making an account' do
      before do
        click_on 'Register'
      end
      context 'when the form is correctly filled' do
        specify 'I can create a new account' do
          fill_in 'Email', with: 'john_smith@outlook.com'
          fill_in 'Name', with: 'John'
          fill_in 'Password', with: 'Password'
          fill_in 'Password confirmation', with: 'Password'
          click_on 'Sign up'
          expect(page).to have_content 'Welcome! You have signed up successfully.'
        end
      end

      context 'when the form is filled incorrectly' do
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
      create(:user)
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
