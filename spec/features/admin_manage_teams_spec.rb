# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin Manage Teams', :js do
  let!(:site_admin) { create :user, :site_admin }
  let!(:team_count) { 2 }

  let!(:users) { create_list :user, 20 }
  let!(:teams) { create_list :team, team_count }

  let!(:tr_player) { create :team_role, :manager }
  let!(:tr_manager) { create :team_role, :player }

  # TODO: Figure out how to prevent suite specific automatic DB cleanup
  before do
    teams.each do |team|
      owner = team.owner
      manager = rand > 0.6 ? users.sample : owner
      ut = team.user_teams.create user: manager
      ut.roles << tr_manager

      num_players = rand 2..5
      users.sample(num_players).each do |user|
        ut = team.user_teams.create user: user
        ut.roles << tr_player
      end
    end

    sleep 0.2

    visit '/'
    fill_in 'user[email]', with: site_admin.email
    fill_in 'user[password]', with: 'password'
    click_on 'Log in'
    click_on 'Admin'

    click_on 'Teams'
  end

  specify 'The team cards are being loaded onto the page' do
    expect(page).to have_css('.team-card', count: team_count, visible: :visible)
  end

  specify 'The team card\'s id matches the corresponding team name' do
    all(:css, '.team_card').each do |card|
      team_id = card[:id]
      team = Team.find_by id: team_id
      name = card.find('.team-name').native.text
      expect(name).to eq team.name
    end
  end

  specify 'The team card\'s manager name matches the corresponding team manager' do
    all(:css, '.team_card').each do |card|
      team_id = card[:id]
      team = Team.find_by id: team_id
      manager = User.find_by id: team.owner_id
      name = card.find('.manager-name').native.text
      expect(name).to eq manager.name
    end
  end

  context 'when editing the teams' do
    def random_card
      cards = all :css, '.team-card'
      index = rand(cards.size)
      cards[index]
    end

    def get_team_id(team_card)
      dom_id = team_card[:id]
      dom_id.split('-')[-1]
    end

    specify 'I can change a team\'s owner', :js do
      team_card = random_card
      team_card.click

      team_id = get_team_id team_card
      team = Team.find_by id: team_id

      q_other_users = User.where.not id: team.owner.id
      num_other_users = q_other_users.count
      new_owner = q_other_users.offset(rand(num_other_users)).first

      within team_card do
        find(:css, '[name="live-search-owner"]').set new_owner.name
        sleep 0.2
        find(:css, ".live-search-entry[data-owner-id='#{new_owner.id}']").click
      end

      sleep 0.2

      expect(team.reload.owner_id).to eq new_owner.id
    end

    specify 'I can remove a member from a team' do
      team_card = random_card
      team_card.click

      to_delete = nil
      within team_card do
        members = all '.tc-member'
        to_delete = members.sample
      end

      member_id = to_delete['data-id']

      within to_delete do
        click_on 'Delete'
      end

      sleep 0.1

      team_id = team_card['data-id']
      user_team = UserTeam.find_by user_id: member_id, team_id: team_id
      expect(user_team).to be_nil
    end

    context 'When adding members' do
      let!(:team_card) { random_card }
      let!(:team_id) { team_card['data-id'] }
      let!(:new_member) do
        my_members_ids = UserTeam.where(team_id: team_id).pluck :user_id
        q_other_users = User.where.not(id: my_members_ids)

        num_other_users = q_other_users.count
        q_other_users.offset(rand(num_other_users)).first
      end

      before do
        team_card.click

        within team_card do
          find(:css, '[name="live-search-team-new-member"]').set new_member.name
          find(:css, ".live-search-entry[data-user-id='#{new_member.id}']").click
        end
      end

      specify 'I can add a roleless member to a team' do
        within team_card do
          click_on 'Add'
        end

        sleep 0.2

        new_user_team = UserTeam.find_by team_id: team_id, user_id: new_member.id
        expect(new_user_team).not_to be_nil
      end

      specify 'I can add a player to a team' do
        within team_card do
          find(:css, '[name="live-search-nm-team-role"]').set tr_player.name
          find(:css, '.live-search-entry').click
          click_on 'Add'
        end

        sleep 0.2

        new_user_team = UserTeam.find_by team_id: team_id, user_id: new_member.id
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

        new_user_team = UserTeam.find_by team_id: team_id, user_id: new_member.id
        player_role = new_user_team.roles.where id: tr_manager.id
        expect(player_role).not_to be_nil
      end
    end

    context 'when I search for a member' do
      specify 'Members that are already in the team do not show up' do
        team_card = random_card
        team_card.click

        team_id = team_card['data-id']

        my_players_ids = UserTeam.where(team_id: team_id).pluck :user_id
        target_id = my_players_ids.sample
        target = User.find_by id: target_id

        within team_card do
          find(:css, '[name="live-search-team-new-member"]').set target.name
        end

        expect(team_card).to have_no_css ".live-search-entry[data-user-id='#{target.id}'"
      end
    end
  end
end
