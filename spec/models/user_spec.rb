# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  name                   :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
require 'rails_helper'

RSpec.describe User do
  # TODO: Move these to factories
  let!(:role_player) { Role.find_or_create_by! name: 'Player' }
  let!(:role_manager) { Role.find_or_create_by! name: 'Manager' }

  describe 'role awareness' do
    it 'UserDecorator.site_admin? returns true on admins' do
      sa = described_class.create email: 'grand@authority.com', password: 'password', name: 'Eye of Sauron'
      SiteAdmin.create user_id: sa.id
      expect(sa.decorate.site_admin?).to be true
    end

    it 'UserDecorator.site_admin? returns false on players' do
      player = described_class.create email: 'player@1.com', password: 'password', name: 'Striking Name'
      UserRole.create user_id: player.id, role_id: role_player.id
      expect(player.decorate.site_admin?).to be false
    end

    it 'UserDecorator.site_admin? returns false on managers' do
      manager = described_class.create email: 'da@manager.com', password: 'password', name: 'Striking Name (Retired)'
      UserRole.create user_id: manager.id, role_id: role_manager.id
      expect(manager.decorate.site_admin?).to be false
    end
  end
end
