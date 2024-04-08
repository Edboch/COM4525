# frozen_string_literal: true

require 'rails_helper'
require 'rspec/expectations'
RSpec.describe 'Admin Edit Users', :js do
  let!(:site_admin) do
    sa = User.create email: 'grand@authority.com', password: 'password', name: 'Eye of Sauron'
    SiteAdmin.create user_id: sa.id
    sa
  end

  # TODO: Player and Manager generation to factories
  let!(:player) do
    user = User.create email: 'player@1.com', password: 'password', name: 'John'
    role_player = Role.find_or_create_by! name: 'Player'
    UserRole.create user_id: user.id, role_id: role_player.id
    user
  end

  before do
    visit '/'
    fill_in 'user[email]', with: site_admin.email
    fill_in 'user[password]', with: 'password'
    click_on 'Log in'
    click_on 'Admin'

    click_on 'Users'
  end

  specify 'The user cards are being loaded onto the page' do
    expect(page).to have_css("#user-#{player.id}.user-card", visible: :visible)
  end

  specify 'A user\'s name can be changed', :js do
    user_card = find('.user-card')
    user_card.click
    within user_card do
      find(:css, '[name="name"]').set('Dominic')
      find(:css, 'button.save').click
    end

    sleep 0.2
    expect(player.reload.name).to eq 'Dominic'
  end

  specify 'A user\'s email can be changed' do
    email = 'get.me.out.of.here@outlook.com'

    user_card = find('.user-card')
    user_card.click
    within user_card do
      find(:css, '[name="email"]').set email
      click_on 'Save'
    end

    sleep 0.2
    expect(player.reload.email).to eq email
  end
  
  pending 'A user can be deleted from the admin page' do
    # Error message: ActiveRecord::RecordNotFound: Couldn't find User with [WHERE "users"."id" = $1]
    #user_email = nil
    #first_user_id = nil
    #email = nil
    #user_card = find('.user-card')
    #user_card.click
    #within user_card do
      #first_user_id = player.id
      #first_user_id = find(:css, '[name="User id"]')
      #print(first_user_id)
      #find(:css, 'button.remove').click
      #user_email = find(:css, '[name="email"]')
    #end
    #sleep 0.2
    #expect(player.reload).to be_nil
    #expect(player.reload.id).not_to eql(first_user_id)
    #expect(player.reload).to raise_error
  end
end
