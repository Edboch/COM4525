# frozen_string_literal: true

# == Schema Information
#
# Table name: team_roles
#
#  id   :bigint           not null, primary key
#  name :string           not null
#  type :integer
#
class TeamRole < ApplicationRecord
  enum :type, %i[managerial staff regular]

  # As UserTeamRole is a join table, no need for dependent: :destroy
  has_many :user_team_roles, dependent: :destroy
  has_many :user_teams, through: :user_team_roles
end
