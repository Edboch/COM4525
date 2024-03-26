# frozen_string_literal: true

require 'rails_helper'

# Testing for Match CRUD functionality
# (including fixture display)
RSpec.describe 'Managing Matches' do
  let!(:manager1) { create(:user, :manager) }
  let!(:role_manager) { Role.find_or_create_by! name: 'Manager' }

  let!(:team) { create(:team) }

  # navigate to appropriate page
  before do
    UserRole.create user_id: manager1.id, role_id: role_manager.id

    t = team
    t.owner_id = manager1.id
    t.save
    create(:match, team: team, opposition: 'Past Opposition', start_time: 1.day.ago)
    create(:match, team: team, opposition: 'Future Opposition', start_time: 1.day.from_now)

    visit '/'
    login_as(manager1, scope: :user)
    visit dashboard_path
    click_on 'View team'
  end

  # Creating match testing
  context 'when I am logged in as a manager on the team view' do
    specify 'then I can create a new match' do
      click_on 'Add a Match'
      fill_in 'location', with: 'New Location'
      fill_in 'opposition', with: 'New Opposition'
      click_on 'Submit'
      expect(page).to have_content 'Match was successfully created.'
    end
  end

  # Viewing and editing match testing
  context 'when I am logged in as a manager on the fixture view' do
    before do
      click_on 'View Fixtures'
    end

    specify 'then I can view a match' do
      expect(page).to have_content 'Past Opposition'
    end

    # test the future and past differences with editing a match
    specify 'then I am able to edit the goals of a past match' do
      within('tr', text: 'Past Opposition') do
        click_on 'Edit'
      end
      expect(page).to have_content 'Goals for'
    end

    specify 'then I am not able to edit the goals of a future match' do
      within('tr', text: 'Future Opposition') do
        click_on 'Edit'
      end
      expect(page).to have_no_content 'Goals for'
    end

    # test general editing functionality of a match
    specify 'then I can edit a match' do
      within('tr', text: 'Future Opposition') do
        click_on 'Edit'
      end
      fill_in 'location', with: 'Edited Location'
      click_on 'Submit'
      expect(page).to have_content 'Match was successfully updated.'
    end
  end
end
