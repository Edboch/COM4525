# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Managing public match invites' do
  let!(:manager) { create(:user) }
  let!(:team) { create(:team) }

  before do
    team.owner_id = manager.id
    team.save
    create(:invite, team_id: team.id)
    visit '/'
    login_as(manager, scope: :user)
    visit dashboard_path
    click_on 'View Team'
  end

  context 'when I am logged in as a manager on the team view' do
    specify 'I can post a new public match invite' do
      click_on 'Publish a new public invite'
      fill_in 'invite[location]', with: 'Sheffield'
      fill_in 'invite[description]', with: 'We like having matches!'
      click_on 'Create Invite'
      expect(page).to have_content 'Invite was successfully created.'
    end

    specify 'I can edit a posted public match invite' do
      click_on 'All Published Public Invites'
      click_on 'Show'
      click_on 'Edit'
      fill_in 'invite[description]', with: 'To test if the edit feature works.'
      click_on 'Create Invite'
      expect(page).to have_content 'To test if the edit feature works.'
    end

    specify 'I can delete a posted public match invite' do
      click_on 'All Published Public Invites'
      click_on 'Show'
      click_on 'Delete'
      expect(page).to have_content 'Invite was successfully deleted.'
    end
  end
end
