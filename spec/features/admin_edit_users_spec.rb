# frozon_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin Edit Users', js: true do

  before :each do
    @sa = User.create email: 'grand@authority.com', password: 'password', name: 'Eye of Sauron'
    SiteAdmin.create user_id: @sa.id

    @player = Player.create email: 'player@1.com', password: 'password', name: 'John'

    visit '/'
    fill_in 'user[email]', with: @sa.email
    fill_in 'user[password]', with: 'password'
    click_on 'Log in'
    click_on 'Admin'

    click_button 'Users'
  end

  specify 'The user cards are being loaded onto the page' do
    expect(page).to have_selector("#user-#{@player.id}.user-card", visible: true)
  end

  specify 'A user\'s name can be changed', js: true do
    user_card = find(".user-card")
    user_card.click
    within user_card do
      find(:css, '[name="name"]').set('Dominic')
      find(:css, 'button.save').click
    end

    sleep 0.5
    expect(@player.reload.name).to eq 'Dominic'
  end

  specify 'A user\'s email can be changed' do
    email = 'get.me.out.of.here@outlook.com'

    user_card = find(".user-card")
    user_card.click
    within user_card do
      find(:css, '[name="email"]').set email
      click_on 'Save'
    end

    sleep 0.5
    expect(@player.reload.email).to eq email
  end
end

