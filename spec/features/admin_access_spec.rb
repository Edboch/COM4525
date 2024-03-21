# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin Access' do
  let!(:regular) { create :user }
  let!(:admin) { create :user, :site_admin }

  before do
    regular
    admin

    visit '/'
  end

  specify 'A site visitor cannot access the site admin page' do
    visit admin_page_path(admin)
    expect(page).to have_content 'You are not authorized to access this page.'
  end

  context 'when I log in as a regular user' do
    before do
      fill_in 'user[email]', with: regular.email
      fill_in 'user[password]', with: 'password'
      click_on 'Log in'
    end

    specify 'The admin button does not show up' do
      expect(page).not_to have_link(href: admin_page_path(regular))
    end

    specify 'I cannot access the admin page via url' do
      visit admin_page_path(regular)
      expect(page).to have_content 'You are not authorized to access this page.'
    end
  end

  context 'when I log in as an admin' do
    before do
      fill_in 'user[email]', with: admin.email
      fill_in 'user[password]', with: 'password'
      click_on 'Log in'
    end

    specify 'The admin button does show up' do
      expect(page).to have_link(href: admin_page_path(admin))
    end

    specify 'I can access the admin page via url' do
      visit admin_page_path(regular)
      expect(page).not_to have_content 'You are not authorized to access this page.'
    end

    specify 'I can access the admin page via the admin button' do
      within 'nav.lnd-nav' do
        click_on 'Admin'
      end
      expect(page).to have_content 'General Stats'
    end
  end
end
