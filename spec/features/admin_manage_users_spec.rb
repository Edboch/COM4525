# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin Edit Users', :js do
  let!(:admin) { create(:user, :site_admin) }
  let!(:regular) { create(:user) }

  before do
    regular
    visit '/'
    fill_in 'user[email]', with: admin.email
    fill_in 'user[password]', with: 'password'
    click_on 'Log in'
    click_on 'Admin'

    click_on 'Users'
  end

  context 'when editing existing users' do
    let!(:user_card) do
      uc = find "#user-card-#{regular.id}"
      uc.click
      uc
    end

    specify 'The user cards are being loaded onto the page' do
      expect(page).to have_css("#user-card-#{regular.id}", visible: :visible)
    end

    specify 'A user\'s name can be changed' do
      # save_and_open_page
      within user_card do
        find(:css, 'input[name="name"]').set 'Dominic'
        find(:css, 'button.save').click
      end

      sleep 0.2
      expect(regular.reload.name).to eq 'Dominic'
    end

    specify 'A user\'s email can be changed' do
      email = 'get.me.out.of.here@outlook.com'

      within user_card do
        find(:css, '[name="email"]').set email
        click_on 'Save'
      end

      sleep 0.2
      expect(regular.reload.email).to eq email
    end

    specify 'A user can be made a site admin' do
      within user_card do
        find(:css, '[name="site-admin"]').set true
        click_on 'Save'
      end

      sleep 0.2
      regular.reload
      expect(regular.site_admin).not_to be_nil
    end

    specify 'A user can be deleted' do
      within user_card do
        click_on 'Remove Account'
      end

      sleep 0.2
      user = User.find_by id: regular.id
      expect(user.nil?).to be true
    end
  end

  context 'when creating new users' do
    let!(:name)  { Faker::Name.name }
    let!(:email) { Faker::Internet.email }

    context 'when the form is correctly filled' do
      before do
        within :css, '#new-user' do
          find(:css, '[name="name"]').set name
          find(:css, '[name="email"]').set email
          find_by_id('new-user-regen-pw').click

          find(:css, '[name="site-admin"]').set false
        end
        sleep 0.1
      end

      specify 'I can create a new regular user' do
        within :css, '#new-user' do
          find_by_id('new-user-submit').click
        end

        sleep 0.1

        user = User.find_by email: email
        expect(!user.nil? && user.site_admin.nil?).to be true
      end

      specify 'I can create a new site admin' do
        within :css, '#new-user' do
          find(:css, '[name="site-admin"]').set true
          find_by_id('new-user-submit').click
        end

        sleep 0.1

        user = User.find_by email: email
        expect(!(user.nil? || user.site_admin.nil?)).to be true
      end
    end

    specify 'And the form is incorrectly filed' do
      within :css, '#new-user' do
        find(:css, '[name="email"]').set email
        find_by_id('new-user-regen-pw').click
        sleep 0.1

        find_by_id('new-user-submit').click
      end

      sleep 0.1
      user = User.find_by email: email
      expect(user).to be_nil
    end
  end
end
