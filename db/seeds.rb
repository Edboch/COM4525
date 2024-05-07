# frozen_string_literal: true

require 'factory_bot_rails'

Team.destroy_all
TeamRole.destroy_all

User.destroy_all
SiteAdmin.destroy_all
Report.destroy_all
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
  user = FactoryBot.create :user

  SiteAdmin.create user_id: user.id if rand(30) < 1

  if rand(30) > 10
    Report.create user_id: user.id, content: 'see if work', solved: true
  else
    Report.create user_id: user.id, content: 'see if work', solved: false
  end
end

##############
## Generate Teams

tr_manager = FactoryBot.create :team_role, :manager
tr_player = FactoryBot.create :team_role, :player

num_users = User.count
num_teams = ((num_users.to_f * 0.8) / rand(8..12)).floor.to_i
teams = FactoryBot.create_list :team, num_teams

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
## Generate User Activity

SiteVisit.destroy_all
TeamActivity.destroy_all

date_start = 3.years.ago
last_day = Time.current.beginning_of_day

Team.find_each do |team|
  day = rand(date_start...Time.current).beginning_of_day
  while day <= last_day
    num_visits = rand(0..team.users.size)
    num_visits = [1, num_visits].max
    TeamActivity.create team: team, day_start: day, active_users: num_visits

    v_end = rand(day..day.end_of_day)
    v_end = [v_end, Time.current].min
    limit = v_end - 2.hours
    v_start = rand(limit..v_end)
    SiteVisit.create visit_start: v_start, visit_end: v_end

    day += [1, 1, 1, 1, 2, 2, 3, 4].sample.days
  end
end

rand(300..500).times do
  v_start = rand(date_start...2.hours.ago)
  limit = v_start + 1.hour + 59.minutes + 50.seconds
  v_end = rand(v_start...limit)

  SiteVisit.create visit_start: v_start, visit_end: v_end
end

Rake::Task['site_visits:collate'].invoke
