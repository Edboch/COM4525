# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin Manage Teams', :js do
  let!(:site_admin) { create(:user, :site_admin) }
  let!(:team_count) { 2 }

  # TODO: Figure out how to prevent suite specific automatic DB cleanup
  before do
    players = create_list(:user, 10, :player)
    managers = create_list(:user, 3, :manager)
    teams = create_list(:team, team_count)

    teams.each do |team|
      m = managers.sample
      team.owner_id = m.id
      team.save

      num_players = rand 2..5
      players.sample(num_players).each do |player|
        UserTeam.create(team_id: team.id, user_id: player.id, accepted: true)
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

    def get_player_id(tc_player)
      dom_id = tc_player[:id]
      re = /t[\d]+-p([\d]+)/
      md = re.match dom_id
      md[1]
    end

    specify 'I can change a team\'s manager', :js do
      team_card = random_card
      team_card.click

      team_id = get_team_id team_card
      team = Team.find_by id: team_id

      manager_id = team.owner_id
      q_other_managers = User.where.not(id: manager_id)
                             .includes(:roles).where(roles: { name: 'Manager' })
      num_other_managers = q_other_managers.count
      new_manager = q_other_managers.offset(rand(num_other_managers)).first

      within team_card do
        find(:css, '[name="manager-search"]').set new_manager.name
        sleep 0.2
        find(:css, '.search-entry').click
      end

      sleep 0.2

      expect(team.reload.owner_id).to eq new_manager.id
    end

    specify 'I can remove a player from a team' do
      team_card = random_card
      team_card.click

      player_to_delete = nil
      within team_card do
        players = all '.tc-player'
        player_to_delete = players.sample
      end

      player_id = get_player_id player_to_delete

      within player_to_delete do
        click_on 'Delete'
      end

      user_team = UserTeam.find_by user_id: player_id, team_id: team_card
      expect(user_team).to be_nil
    end

    specify 'I can add a player to a team' do
      team_card = random_card
      team_card.click

      team_id = get_team_id team_card

      my_players_ids = UserTeam.where(team_id: team_id).pluck :user_id
      q_other_players = User.where.not(id: my_players_ids)
                            .includes(:roles).where(roles: { name: 'Player' })
      num_other_players = q_other_players.count
      new_player = q_other_players.offset(rand(num_other_players)).first

      within team_card do
        find(:css, '[name="player-search"]').set new_player.name
        sleep 0.2
        find(:css, '.search-entry').click
      end

      sleep 0.2

      new_user_team = UserTeam.find_by team_id: team_id, user_id: new_player.id
      expect(new_user_team).not_to be_nil
    end

    context 'when I search for a player' do
      specify 'Players that already in the team do not show up' do
        team_card = random_card
        team_card.click

        team_id = get_team_id team_card

        my_players_ids = UserTeam.where(team_id: team_id).pluck :user_id
        target_id = my_players_ids.sample
        target = User.find_by id: target_id

        within team_card do
          find(:css, '[name="player-search"]').set target.name
        end

        expect(team_card).to have_no_css ".res-#{target.id}"
      end
    end
  end
end
