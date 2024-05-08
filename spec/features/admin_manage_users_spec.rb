# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin Edit Users', :js do
  let!(:admin) { create(:user, :site_admin) }
  let!(:regular) { create(:user) }

  before do
    regular
    visit '/'
    fill_in 'user[email]', with: admin.email
    fill_in 'user[password]', with: 'password'
    click_on 'Log in'
    click_on 'Admin'

    click_on 'Users'
  end

  context 'when editing existing users' do
    let!(:user_card) do
      uc = find "#user-card-#{regular.id}"
      uc.click
      uc
    end

    specify 'The user cards are being loaded onto the page' do
      expect(page).to have_css("#user-card-#{regular.id}", visible: :visible)
    end

    specify 'A user\'s name can be changed' do
      # save_and_open_page
      within user_card do
        find(:css, 'input[name="name"]').set 'Dominic'
        find(:css, 'button.save').click
      end

      sleep 0.2
      expect(regular.reload.name).to eq 'Dominic'
    end

    specify 'A user\'s email can be changed' do
      email = 'get.me.out.of.here@outlook.com'

      within user_card do
        find(:css, '[name="email"]').set email
        click_on 'Save'
      end

      sleep 0.2
      expect(regular.reload.email).to eq email
    end

    specify 'A user can be made a site admin' do
      within user_card do
        find(:css, '[name="site-admin"]').set true
        click_on 'Save'
      end

      sleep 0.2
      regular.reload
      expect(regular.site_admin).not_to be_nil
    end

    context 'when I enter the dedicated page' do
      let!(:tr_player) { create(:team_role, :manager) }
      let!(:tr_manager) { create(:team_role, :player) }

      before do
        create_list(:team, 5)

        ut = UserTeam.new user: regular, team: Team.offset(rand(Team.count)).first
        ut.roles << tr_player
        ut.save

        within user_card do
          click_on 'Go'
        end

        sleep 0.1
      end

      specify 'A user\'s name can be changed' do
        find(:css, '[name="usr-name"]').set 'Dominic'
        click_on 'Save'

        sleep 0.2
        expect(regular.reload.name).to eq 'Dominic'
      end

      specify 'A user\'s email can be changed' do
        email = 'get.me.out.of.here@outlook.com'

        find(:css, '[name="usr-email"]').set email
        click_on 'Save'

        sleep 0.2
        expect(regular.reload.email).to eq email
      end

      specify 'A user can be made a site admin' do
        find(:css, '[name="usr-admin"]').set true
        click_on 'Save'

        sleep 0.2
        regular.reload
        expect(regular.site_admin).not_to be_nil
      end

      specify 'I can add the user to a team as a manager' do
        team_ids_to_avoid = regular.teams.pluck(:id)
        team = Team.where.not(id: team_ids_to_avoid).first

        within :css, 'div.live-search-new-team' do
          find(:css, 'input').set team.name
          # save_and_open_page
          sleep 0.1
          find(:css, '.live-search-entry').click
        end

        within :css, 'div.live-search-new-team-roles' do
          find(:css, 'input').set tr_manager.name
          sleep 0.1
          find(:css, '.live-search-entry').click
        end

        click_on 'Add'
        sleep 0.1
        click_on 'Save'

        sleep 0.1

        regular.reload
        expect(regular.teams.find_by(id: team.id)).not_to be_nil
      end

      specify 'I can remove a user from a team' do
        team = regular.teams.first

        within :css, ".au-team[data-id='#{team.id}']" do
          click_on 'Leave Team'
        end

        click_on 'Save'
        sleep 0.1

        expect(regular.reload.teams.exists?(id: team.id)).to be false
      end

      specify 'I can remove user from a role on a team' do
        team = regular.teams.first
        ut = UserTeam.find_by user: regular, team: team
        role = ut.roles.first

        within :css, ".au-team[data-id='#{team.id}']" do
          find(:css, "[data-role-id='#{role.id}']").click
        end

        click_on 'Save'

        sleep 0.1

        ut.reload
        expect(ut.roles.exists?(role).to_be false
      end
    end
  end

  context 'when creating new users' do
    let!(:name)  { Faker::Name.name }
    let!(:email) { Faker::Internet.email }

    context 'when the form is correctly filled' do
      before do
        within :css, '#new-user' do
          find(:css, '[name="name"]').set name
          find(:css, '[name="email"]').set email
          find_by_id('new-user-regen-pw').click

          find(:css, '[name="site-admin"]').set false
        end
        sleep 0.1
      end

      specify 'I can create a new regular user' do
        within :css, '#new-user' do
          find_by_id('new-user-submit').click
        end

        sleep 0.1

        user = User.find_by email: email
        expect(!user.nil? && user.site_admin.nil?).to be true
      end

      specify 'I can create a new site admin' do
        within :css, '#new-user' do
          find(:css, '[name="site-admin"]').set true
          find_by_id('new-user-submit').click
        end

        sleep 0.1

        user = User.find_by email: email
        expect(!(user.nil? || user.site_admin.nil?)).to be true
      end
    end

    specify 'And the form is incorrectly filed' do
      within :css, '#new-user' do
        find(:css, '[name="email"]').set email
        find_by_id('new-user-regen-pw').click
        sleep 0.1

        find_by_id('new-user-submit').click
      end

      sleep 0.1
      user = User.find_by email: email
      expect(user).to be_nil
    end
  end
end
