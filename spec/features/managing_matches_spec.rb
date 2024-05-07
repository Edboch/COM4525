# frozen_string_literal: true

require 'rails_helper'

# Testing for Match CRUD functionality
# (including fixture display)
RSpec.describe 'Managing Matches' do
  let!(:manager1) { create(:user) }

  let!(:team) { create(:team) }

  # navigate to appropriate page
  before do
    team.owner_id = manager1.id
    team.save
    create(:match, team: team, opposition: 'Past Opposition', start_time: 1.day.ago)
    create(:match, team: team, opposition: 'Future Opposition', start_time: 1.day.from_now)

    visit '/'
    login_as(manager1, scope: :user)
    visit dashboard_path
    click_on 'View Team'
  end

  # Creating match testing
  context 'when I am logged in as a manager on the team view' do
    before do
      click_on 'Add a Match'
    end

    specify 'then I can create a new match' do
      fill_in 'location', with: 'New Location'
      fill_in 'opposition', with: 'New Opposition'
      click_on 'Submit'
      expect(page).to have_content 'Match was successfully created.'
    end

    specify 'then i can edit a match with a specific date' do
      fill_in 'location', with: 'New Location'
      fill_in 'opposition', with: 'New Opposition'
      select '2024', from: 'match[start_time(1i)]'
      select 'May', from: 'match[start_time(2i)]'
      select '5', from: 'match[start_time(3i)]'
      select '13', from: 'match[start_time(4i)]'
      select '00', from: 'match[start_time(5i)]'
      click_on 'Submit'
      expect(page).to have_content '05/05/2024'
    end
  end

  # Viewing and editing match testing
  context 'when I am logged in as a manager on the fixture view' do
    before do
      click_on 'All Fixtures'
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

    specify 'then i can delete a match' do
      within('tr', text: 'Future Opposition') do
        click_on 'Delete'
      end
      expect(page).to have_content 'Match was successfully deleted.'
    end
  end
end
