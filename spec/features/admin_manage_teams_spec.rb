# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin Manage Teams', :js do
  let!(:site_admin) { create(:user, :site_admin) }
  let!(:player) { create(:user) }
  let!(:manager) { create(:user) }
  let!(:new_user) { create(:user) }

  let!(:team) { create(:team, owner_id: manager.id, name: 'Sample Team') }

  let!(:tr_player) { create(:team_role, :player) }
  let!(:tr_manager) { create(:team_role, :manager) }

  let!(:ut_player) { create(:user_team, team_id: team.id, user_id: player.id, accepted: true) }

  def random_card
    cards = all :css, '.team-card'
    index = rand(cards.size)
    cards[index]
  end

  def get_team_id(capy_team_card)
    dom_id = capy_team_card[:id]
    dom_id.split('-')[-1]
  end

  # TODO: Figure out how to prevent suite specific automatic DB cleanup
  before do
    ut_player.roles << tr_player

    sleep 0.2

    login_as(site_admin, scope: :user)
    visit dashboard_path
    click_on 'Admin'
    click_on 'Teams'
  end

  # rubocop:disable RSpec/ScatteredLet
  let!(:team_card) { random_card }
  let!(:team_id) { team_card['data-id'] }
  # rubocop:enable RSpec/ScatteredLet

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
    before do
      team_card.click
    end

    specify 'I can change a team\'s name' do
      new_name = 'The Grangers'

      within team_card do
        find(:css, 'input[name="team-name"]').set new_name
        click_on 'Save'
      end

      sleep 0.2

      team = Team.find_by id: team_id
      expect(team.name).to eq new_name
    end

    specify 'I can change a team\'s location name' do
      new_loc_name = 'Sheffield'

      within team_card do
        find(:css, 'input[name="team-location"]').set new_loc_name
        click_on 'Save'
      end

      sleep 0.2

      team = Team.find_by id: team_id
      expect(team.location_name).to eq new_loc_name
    end

    specify 'I can change a team\'s owner' do
      team = Team.find_by id: team_id

      q_other_users = User.where.not id: team.owner.id
      num_other_users = q_other_users.count
      new_owner = q_other_users.offset(rand(num_other_users)).first

      within team_card do
        find(:css, '[name="live-search-owner"]').set new_owner.name
        sleep 0.2
        find(:css, '.live-search-entry').click
      end

      click_on 'Save'

      sleep 0.2

      expect(team.reload.owner_id).to eq new_owner.id
    end
  end

  context 'when I enter the dedicated page' do
    before do
      within team_card do
        click_on 'Go'
      end
    end

    specify 'I can remove a member from a team' do
      members = all '.tc-member'
      to_delete = members.sample

      member_id = to_delete['data-id']

      within to_delete do
        click_on 'Delete'
      end

      sleep 0.1
      click_on 'Save'

      sleep 0.2

      user_team = UserTeam.find_by user_id: member_id, team_id: team.id
      expect(user_team).to be_nil
    end

    specify 'I can remove this team' do
      click_on 'Delete This Team'
      expect(page).to have_content "Team 'Sample Team' successfully deleted"
    end

    context 'when adding members' do
      let!(:new_member) do
        my_members_ids = UserTeam.where(team_id: team_id).pluck :user_id
        q_other_users = User.where.not(id: my_members_ids)

        num_other_users = q_other_users.count
        q_other_users.offset(rand(num_other_users)).first
      end

      before do
        find(:css, '[name="live-search-new-member"]').set new_member.name
        find(:css, '.live-search-entry').click
      end

      specify 'I can add a player to a team' do
        find(:css, '[name="live-search-new-member-roles"]').set tr_player.name
        find(:css, '.live-search-entry').click
        click_on 'Add'
        sleep 0.1
        click_on 'Save'

        sleep 0.2

        new_user_team = UserTeam.find_by team_id: team.id, user_id: new_member.id
        player_role = new_user_team.roles.where id: tr_player.id
        expect(player_role).not_to be_nil
      end

      specify 'I can add a manager to a team' do
        find(:css, '[name="live-search-new-member-roles"]').set tr_manager.name
        find(:css, '.live-search-entry').click
        click_on 'Add'
        sleep 0.1
        click_on 'Save'

        sleep 0.2

        new_user_team = UserTeam.find_by team_id: team.id, user_id: new_member.id
        player_role = new_user_team.roles.where id: tr_manager.id
        expect(player_role).not_to be_nil
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
