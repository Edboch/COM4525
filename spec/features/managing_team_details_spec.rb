# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Managing team details' do
  let!(:manager1) { create(:user, :manager) }
  let!(:role_manager) { Role.find_or_create_by! name: 'Manager' }

  before do
    UserRole.create user_id: manager1.id, role_id: role_manager.id
    create(:team)
    visit '/'
    login_as(manager1, scope: :user)
    visit dashboard_path
  end

  context 'when I am logged in as a manager' do
    specify 'Then I can view manager dashboard' do
      expect(page).to have_content 'Manage Your Team'
    end

    specify 'Then i can create a new team' do
      click_on 'Create a new team'
      fill_in 'Name', with: 'Own goals'
      fill_in 'team[location_name]', with: 'Sheffield'
      click_on 'Create Team'
      expect(page).to have_content 'Team was successfully created'
    end

    # specify 'Then I cannot make team with no details' do
    #   click_on 'Create a new team'
    #   click_on 'Create Team'
    #   expect(page).to have_content 'Please fill in the blanks'
    # end
  end

  context 'when I have created a team' do
    specify 'then I can see the team on the dashboard' do
      click_on 'View team'
      expect(page).to have_content 'TeamName'
    end

    specify 'Then I can edit the team details' do
      click_on 'View team'
      click_on 'Edit'
      fill_in 'Name', with: 'NewTeamName'
      click_on 'Update Team'
      expect(page).to have_content 'Team name: NewTeamName'
    end

    # specify 'Then I cannot change details to be empty' do
    #   click_on 'View team'
    #   click_on 'Edit'
    #   fill_in 'Name', with: ''
    #   click_on 'Update Team'
    #   expect(page).to have_content 'Cannot have empty cells'
    # end

    specify 'Then i can delete my team' do
      click_on 'View team'
      click_on 'Delete'
      expect(page).to have_content 'Team was successfully deleted.'
    end
  end
end
