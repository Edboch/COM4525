# == Schema Information
#
# Table name: user_team_roles
#
#  team_role_id :bigint           not null
#  user_team_id :bigint           not null
#
# Indexes
#
#  index_user_team_roles_on_team_role_id  (team_role_id)
#  index_user_team_roles_on_user_team_id  (user_team_id)
#
require 'rails_helper'

RSpec.describe UserTeamRole, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
