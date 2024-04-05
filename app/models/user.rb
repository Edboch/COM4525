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
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :user_teams, dependent: :destroy
  has_many :teams, through: :user_teams

  def owner_of_team?(team, user)
    team.owner_id == user.id
  end

  # checks whether the user has the privileges of staff
  # TODO change this to fit CanCan authorisation
  def staff_of_team?(team, user)
    return true if team.owner_id == user.id

    user_teams.joins(:roles, :team)
              .exists?(teams: { id: team.id }, roles: { type: 1 })
  end

  def player_of_team?(team)
    user_teams.joins(:roles, :team)
              .exists?(teams: { id: team.id }, roles: { type: 0 })
  end

  has_many :owned_teams, class_name: :Team, foreign_key: :owner_id, dependent: :destroy, inverse_of: :owner do
    def destroy(team)
      # TODO
    end
  end

  has_one :site_admin, dependent: :destroy
end
