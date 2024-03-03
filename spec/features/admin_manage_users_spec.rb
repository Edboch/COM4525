# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin Edit Users', :js do
  let!(:site_admin) do
    sa = User.create email: 'grand@authority.com', password: 'password', name: 'Eye of Sauron'
    SiteAdmin.create user_id: sa.id
    sa
  end

  # TODO: Player and Manager generation to factories
  let!(:player) do
    user = User.create email: 'player@1.com', password: 'password', name: 'John'
    role_player = Role.find_or_create_by! name: 'Player'
    UserRole.create user_id: user.id, role_id: role_player.id
    user
  end

  before do
    visit '/'
    fill_in 'user[email]', with: site_admin.email
    fill_in 'user[password]', with: 'password'
    click_on 'Log in'
    click_on 'Admin'

    click_on 'Users'
  end

  context 'when editing existing users' do
    specify 'The user cards are being loaded onto the page' do
      expect(page).to have_css("#user-#{player.id}.user-card", visible: :visible)
    end

    specify 'A user\'s name can be changed', :js do
      user_card = find('.user-card')
      user_card.click
      within user_card do
        find(:css, '[name="name"]').set('Dominic')
        find(:css, 'button.save').click
      end

      sleep 0.2
      expect(player.reload.name).to eq 'Dominic'
    end

    specify 'A user\'s email can be changed' do
      email = 'get.me.out.of.here@outlook.com'

      user_card = find('.user-card')
      user_card.click
      within user_card do
        find(:css, '[name="email"]').set email
        click_on 'Save'
      end

      sleep 0.2
      expect(player.reload.email).to eq email
    end
  end

  context 'when creating new users' do
    context 'when the form is correctly filled' do
      before do
        email = "test#{rand(1...1000)}@email.com"
        within :css, '#new-user' do
          find(:css, '[name="name"]').set 'Michael Jones'
          find(:css, '[name="email"]').set email
          find_by_id('new-user-regen-pw').click

          find(:css, '[name="player"]').set false
          find(:css, '[name="manager"]').set false
        end
        sleep 0.1
      end

      specify 'I can create a new player' do
        email = ''
        within :css, '#new-user' do
          find(:css, '[name="player"]').set true
          find_by_id('new-user-submit').click
          email = find(:css, '[name="email"]').value
        end

        sleep 0.2

        user = User.find_by email: email
        expect(!user.nil? && user.player? && !user.manager?).to be true
      end

      specify 'I can create a new manager' do
        email = ''
        within :css, '#new-user' do
          find(:css, '[name="manager"]').set true
          find_by_id('new-user-submit').click
          email = find(:css, '[name="email"]').value
        end

        sleep 0.2

        user = User.find_by email: email
        expect(!user.nil? && !user.player? && user.manager?).to be true
      end
    end

    specify 'And the form is incorrectly filed' do
      email = "test#{rand(1...1000)}@email.com"
      within :css, '#new-user' do
        find(:css, '[name="email"]').set email
        find_by_id('new-user-regen-pw').click
        sleep 0.1

        find(:css, '[name="player"]').set true
        find_by_id('new-user-submit').click
      end

      sleep 0.2
      user = User.find_by email: email
      expect(user).to be_nil
    end
  end
end
