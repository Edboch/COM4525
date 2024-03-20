# frozen_string_literal: true

require 'factory_bot_rails'

UserTeamRole.first.destroy
Team.destroy_all

User.destroy_all
SiteAdmin.destroy_all

############
# Known Users
# So we can log in is a specific role during development
sa_user = User.create email: 'site-admin@grr.la', password: 'password', name: 'Dominic Admin'
SiteAdmin.create user_id: sa_user.id

User.create email: 'player@grr.la', password: 'password', name: 'Player Messi'

manager = User.create email: 'manager@grr.la', password: 'password', name: 'John Manager'

##############
### Generate Users

rand(80..100).times do
  user = FactoryBot.create :user, :proper_password

  SiteAdmin.create user_id: user.id if rand(30) < 1
end

##############
## Generate Teams

tr_manager = FactoryBot.create :team_role, :manager
tr_player = FactoryBot.create :team_role, :player

num_users = User.count
num_teams = ((num_users.to_f * 0.8) / rand(8..12)).floor.to_i
teams = FactoryBot.create_list :team, num_teams, :random_manager

max_per_team = (num_users / (num_teams + 1)).clamp(1, 16)
min_per_team = [max_per_team / 2, 1].max

teams.each do |team|
  num_players = rand min_per_team..max_per_team

  owner = team.owner
  manager = rand > 0.8 ? User.offset(rand(num_users)).first : owner
  ut = team.user_teams.create user_id: manager.id
  ut.roles << tr_manager

  player_ids = User.where.not(id: team.owner.id).pluck :id
  num_players.times do
    player_id = player_ids.delete_at rand(player_ids.size)
    ut = team.user_teams.create user_id: player_id
    ut.roles << tr_player
  end
end

############
## Generate Page Visits

date_start = 3.years.ago

rand(1200..1500).times do |_i|
  next_visit_time = rand(date_start..20.minutes.ago)
  rand(1..20).times do |_j|
    v_start = next_visit_time
    v_end = v_start + rand(0..5).minutes + rand(1..59).seconds
    PageVisit.create visit_start: v_start, visit_end: v_end
    break if v_end > Time.current
  end
end

Rake::Task['page_visits:collate_visits'].invoke
