# frozen_string_literal: true

# frozon_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin Edit Users', :js do
  let!(:site_admin) do
    sa = User.create email: 'grand@authority.com', password: 'password', name: 'Eye of Sauron'
    SiteAdmin.create user_id: sa.id
    sa
  end

  let!(:player) { Player.create email: 'player@1.com', password: 'password', name: 'John' }

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
end
