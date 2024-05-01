# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Managing team details' do
  let!(:manager1) { create(:user) }
  let!(:team) { create(:team) }

  before do
    team.owner_id = manager1.id # make manager1 the owner of the team
    team.save

    visit '/'
    login_as(manager1, scope: :user)
    visit dashboard_path
  end

  context 'when I am logged in as a manager' do
    specify 'Then I can view manager dashboard' do
      expect(page).to have_content 'Manage'
    end

    specify 'Then i can create a new team' do
      click_on 'Create a new team'
      fill_in 'Name', with: 'Own goals'
      fill_in 'team[location_name]', with: 'Sheffield'
      click_on 'Create Team'
      expect(page).to have_content 'Team was successfully created'
    end
  end

  context 'when I have created a team' do
    specify 'then I can see the team on the dashboard' do
      click_on 'View Team'
      expect(page).to have_content team.name
    end

    specify 'Then I can edit the team details' do
      click_on 'View Team'
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
      click_on 'View Team'
      click_on 'Delete'
      expect(page).to have_content 'Team was successfully deleted.'
    end
  end
end
