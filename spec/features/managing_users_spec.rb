require 'rails_helper'

RSpec.feature 'Managing users' do 
  context 'when I am not a registered user' do
    before do
      visit '/dashboard'
    end

    specify 'then I will be redirected to the login page' do
      expect(page).to have_content 'Log in'
    end

    specify 'then I can make an account as a player' do
      visit '/users/sign_up'
      fill_in 'user_email', with: 'test@email.com'
      fill_in 'user_password', with: 'Password'
      fill_in 'user_password_confirmation', with: 'Password'
      click_button 'Sign up'

      expect(page).to have_content('Logout')
    end

    specify 'then I can make an account as a player' do

    end
  end
end