# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin Manage Teams', :js do
  let!(:site_admin) { create(:user, :site_admin) }
  let!(:player) { create(:user) }
  let!(:manager) { create(:user) }
  let!(:new_user) { create(:user) }

  let!(:team) { create(:team, owner_id: manager.id) }

  let!(:tr_player) { create(:team_role, :player) }
  let!(:tr_manager) { create(:team_role, :manager) }

  let!(:ut_player) { create(:user_team, team_id: team.id, user_id: player.id, accepted: true) }

  # TODO: Figure out how to prevent suite specific automatic DB cleanup
  before do
    ut_player.roles << tr_player

    sleep 0.2

    login_as(site_admin, scope: :user)
    visit dashboard_path
    click_on 'Admin'
    click_on 'Teams'
  end

  specify 'The team cards are being loaded onto the page' do
    expect(page).to have_css('.team-card', count: 1, visible: :visible)
  end

  specify 'The team card\'s id matches the corresponding team name' do
    expect(page).to have_content team.name
  end

  specify 'The team card\'s manager name matches the corresponding team manager' do
    expect(page).to have_content manager.name
  end

  context 'when editing the teams' do
    specify 'I can change a team\'s owner', :js do
      team_card = find "#team-card-#{team.id}"
      team_card.click

      new_owner = new_user

      within team_card do
        find(:css, '[name="live-search-owner"]').set new_owner.name
        sleep 0.2
        find(:css, ".live-search-entry[data-owner-id='#{new_owner.id}']").click
      end

      sleep 0.2

      expect(team.reload.owner_id).to eq new_owner.id
    end

    specify 'I can remove a member from a team' do
      team_card = find "#team-card-#{team.id}"
      team_card.click

      to_delete = find_by_id 'user-team-1'

      member_id = to_delete['data-id']

      within to_delete do
        click_on 'Delete'
      end

      sleep 0.2

      user_team = UserTeam.find_by user_id: member_id, team_id: team.id
      expect(user_team).to be_nil
    end

    context 'when adding members' do
      let!(:team_card) { find "#team-card-#{team.id}" }

      before do
        team_card.click

        within team_card do
          find(:css, '[name="live-search-team-new-member"]').set new_user.name
          find(:css, ".live-search-entry[data-user-id='#{new_user.id}']").click
        end
      end

      specify 'I can add a roleless member to a team' do
        within team_card do
          click_on 'Add'
        end

        sleep 0.2

        new_user_team = UserTeam.find_by team_id: team.id, user_id: new_user.id
        expect(new_user_team).not_to be_nil
      end

      specify 'I can add a player to a team' do
        within team_card do
          find(:css, '[name="live-search-nm-team-role"]').set tr_player.name
          find(:css, '.live-search-entry').click
          click_on 'Add'
        end

        sleep 0.2

        new_user_team = UserTeam.find_by team_id: team.id, user_id: new_user.id
        player_role = new_user_team.roles.where id: tr_player.id
        expect(player_role).not_to be_nil
      end

      specify 'I can add a manager to a team' do
        within team_card do
          find(:css, '[name="live-search-nm-team-role"]').set tr_manager.name
          find(:css, '.live-search-entry').click
          click_on 'Add'
        end

        sleep 0.2

        new_user_team = UserTeam.find_by team_id: team.id, user_id: new_user.id
        player_role = new_user_team.roles.where id: tr_manager.id
        expect(player_role).not_to be_nil
      end
    end

    context 'when I search for a member' do
      specify 'Members that are already in the team do not show up' do
        team_card = find "#team-card-#{team.id}"
        team_card.click

        my_players_ids = UserTeam.where(team_id: team.id).pluck :user_id
        target_id = my_players_ids.sample
        target = User.find_by id: target_id

        within team_card do
          find(:css, '[name="live-search-team-new-member"]').set target.name
        end

        expect(team_card).to have_no_css ".live-search-entry[data-user-id='#{target.id}'"
      end
    end
  end

  context 'when creating a new team' do
    let!(:name) { Faker::Name.name }
    let!(:location) { Faker::Name.name }

    context 'when the form is filled in correctly' do
      before do
        owner = new_user
        within :css, '#new-team' do
          find(:css, '[name="team_name"]').set name
          find(:css, '[name="location_name"]').set location
          find(:css, '[name="live-search-first-owner"]').set owner.name
        end
        sleep 0.1
      end

      specify 'i can create a new team' do
        within :css, '#new-team' do
          find_by_id('new-team-submit').click
        end

        sleep 0.1

        team = Team.find_by name: name
        expect(!team.nil?).to be true
      end
    end

    specify 'And the form is incorrectly filed' do
      within :css, '#new-team' do
        find(:css, '[name="team_name"]').set name
        find(:css, '[name="live-search-first-owner"]').set ''
        sleep 0.1

        find_by_id('new-team-submit').click
      end

      sleep 0.1
      team = Team.find_by name: name
      expect(team).to be_nil
    end
  end
end
