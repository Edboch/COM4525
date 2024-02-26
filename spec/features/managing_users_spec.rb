# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Managing users' do
  context 'when I am not a registered user' do
    before do
      visit '/dashboard'
    end

    specify 'then I will be redirected to the login page' do
      expect(page).to have_content 'Login'
    end

    # specify 'then I can make an account as a player' do
    # end
  end
end
