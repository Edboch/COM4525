# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin Edit Teams', :js do
  # rubocop:disable RSpec/BeforeAfterAll
  before :all do
    players = FactoryBot.create_list :user, 30, :player
    managers = FactoryBot.create_list :user, 10, :manager
    teams = FactoryBot.create_list :team, 4

    teams.each do |team|
      m = managers.sample
      team.owner_id = m.id
      team.save

      num_players = rand 8..13
      players.sample(num_players).each do |player|
        UserTeam.create(team_id: team.id, user_id: player.id, accepted: true)
      end
    end
  end

  after :all do
    
  end
  # rubocop:enable RSpec/BeforeAfterAll

  let!(:site_admin) { FactoryBot.create :user, :site_admin }

  before do
    visit '/'
    fill_in 'user[email]', with: site_admin.email
    fill_in 'user[password]', with: 'password'
    click_on 'Log in'
    click_on 'Admin'

    click_on 'Teams'
  end

  context 'When editing the teams' do
    specify 'The team cards are being loaded onto the page', :js do
      expect(page).to have_css('.team-card', count: 4, visible: :visible)
    end

    specify 'I can change a team\'s manager' do
      puts User.count
    end

    specify 'I can remove a player from a team' do

    end

    specify 'I can add a player to a team' do

    end

    context 'When I search for a player' do
      specify 'Players that already in the team do not show up' do

      end
    end
  end
end
