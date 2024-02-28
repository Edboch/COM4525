# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin Access' do
  specify 'A site visitor cannot access the site admin page' do
    visit '/'
    visit '/dashboard/1/site-admin'
    expect(page).to have_content 'You are not authorized to access this page.'
  end

  specify 'A player cannot access the site admin page' do
    player = Player.create email: 'player@1.com', password: 'password', name: 'Striking Name'

    visit '/'
    fill_in 'user[email]', with: player.email
    fill_in 'user[password]', with: 'password'
    click_on 'Log in'
    visit "/dashboard/#{player.id}/site-admin"
    expect(page).to have_content 'You are not authorized to access this page.'
  end

  specify 'A manager cannot access the site admin page' do
    manager = Manager.create email: 'da@manager.com', password: 'password', name: 'Striking Name (Retired)'

    visit '/'
    fill_in 'user[email]', with: manager.email
    fill_in 'user[password]', with: 'password'
    click_on 'Log in'
    visit "/dashboard/#{manager.id}/site-admin"
    expect(page).to have_content 'You are not authorized to access this page.'
  end

  specify 'A site admin can access the site admin page' do
    sa = User.create email: 'grand@authority.com', password: 'password', name: 'Eye of Sauron'
    SiteAdmin.create user_id: sa.id

    visit '/'
    fill_in 'user[email]', with: sa.email
    fill_in 'user[password]', with: 'password'
    click_on 'Log in'

    within 'nav.lnd-nav' do
      click_on 'Admin'
    end
    expect(page).to have_content 'General Stats'
  end
end
