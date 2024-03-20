# == Schema Information
#
# Table name: team_roles
#
#  id   :bigint           not null, primary key
#  name :string           not null
#
class TeamRole < ApplicationRecord
  # As UserTeamRole is a join table, no need for dependent: :destroy
  has_many :user_team_roles
  has_many :user_teams, through: :user_team_roles
end
