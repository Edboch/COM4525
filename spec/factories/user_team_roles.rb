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
FactoryBot.define do
  factory :user_team_role do
    
  end
end
