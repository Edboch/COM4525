# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Submiting and solving reports' do
  let!(:admin) { create(:user, :site_admin) }
  let!(:manager) { create(:user) }
  let!(:regular) { create(:user) }
  let!(:report) do
    create(:report, user_id: regular.id, content: 'Something to report')
  end

  before do
    admin
    manager
    regular
    visit '/'
  end

  context 'when I am logged in as an admin' do
    before do
      fill_in 'user[email]', with: admin.email
      fill_in 'user[password]', with: 'password'
      click_on 'Log in'
    end

    specify 'I can submit a report' do
      click_on 'Report'
      fill_in 'Detail your Report', with: 'a report'
      click_on 'Submit Report'
      expect(page).to have_content 'Report was successfully submitted.'
    end

    specify 'I can set the status of the report (solve) from false to true', :js do
      click_on 'Admin'
      click_on 'Unsolved Reports'
      ur_card = find "#report-#{report.id}.unsolved-report-card", visible: :visible
      within ur_card do
        click_on 'Solved'
      end
      sleep 0.2
      expect(report.reload.solved).to be true
    end
  end

  context 'when I am logged in as a manager' do
    before do
      fill_in 'user[email]', with: manager.email
      fill_in 'user[password]', with: 'password'
      click_on 'Log in'
    end

    specify 'I can submit a report' do
      click_on 'Report'
      fill_in 'Detail your Report', with: 'a report'
      click_on 'Submit Report'
      expect(page).to have_content 'Report was successfully submitted.'
    end
  end

  context 'when I am logged in as a regular user' do
    context 'when I am logged in as a regular user' do
      before do
        fill_in 'user[email]', with: regular.email
        fill_in 'user[password]', with: 'password'
        click_on 'Log in'
      end

      specify 'I can submit a report' do
        click_on 'Report'
        fill_in 'Detail your Report', with: 'a report'
        click_on 'Submit Report'
        expect(page).to have_content 'Report was successfully submitted.'
      end
    end
  end
end
