# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
role_player = Role.find_or_create_by! name: 'Player'
role_manager = Role.find_or_create_by! name: 'Manager'
role_site_admin = Role.find_or_create_by! name: 'Site Admin'

User.destroy_all
SiteAdmin.destroy_all

############
# Known Users
# So we can log in is a specific role during development
sa_user = User.create email: 'site-admin@grr.la', password: 'password', name: 'Dominic Admin'
SiteAdmin.create user_id: sa_user.id
UserRole.create user_id: sa_user.id, role_id: role_site_admin.id

player = User.create email: 'player@grr.la', password: 'password', name: 'Player Messi'
UserRole.create user_id: player.id, role_id: role_player.id

manager = User.create email: 'manager@grr.la', password: 'password', name: 'John Manager'
UserRole.create user_id: manager.id, role_id: role_manager.id

##############
### Generated users

# TODO: Maybe replace all of this by using Faker?

email_usernames = [
  'test', 'john', 'username', 'what', 'okay', 'naice', 'grimbo',
  'jimothy', 'tominic', 'big.rich', 'whatever', 'expletive',
  'various_expletives', 'note.the.plural'
]

mail_servers = [
  'gmail', 'outlook', 'yahoo', 'hotmail', 'rocketmail', 'shef.ac',
  'gamedevsoc', 'genesys', 'fbx'
]

domain_names = %w[
  org com co cool io game tv ca
  fr_ewwwwww cc
]

passwords = %w[
  password 12345678 pass1234
]

firstnames = %w[
  Michael Matthew Mark Luke John Paul Patrick
  Rebecca Jennifer Amy Jemima Isabelle
]

surnames = %w[
  Smith Cook Xixiang Allen Bateman
  Green Repuga
]

name_suffixes = ['II', 'III', 'Jr.', 'Sr.', 'DC']

# TODO: Improve this by making use of the insert_all method
#       would probably be best to do once players and managers have dedicated tables
rand(35..60).times do
  email = email_usernames.sample + (rand > 0.3 ? rand(1...999_999).to_s : '')
  email += "@#{mail_servers.sample}.#{domain_names.sample}"
  pw = passwords.sample
  name = "#{firstnames.sample} #{surnames.sample}"
  name += " #{name_suffixes.sample}" if rand > 0.8

  roll = rand 100
  user = User.create email: email, password: pw, name: name

  UserRole.create user_id: user.id, role_id: role_player.id if roll < 53
  UserRole.create user_id: user.id, role_id: role_manager.id if roll > 45

  roll = rand 28
  if roll < 1
    UserRole.create user_id: user.id, role_id: role_site_admin.id
    SiteAdmin.create user_id: user.id
  end
end

q_ur_players = UserRole.where(role_id: role_player.id)
q_ur_managers = UserRole.where(role_id: role_manager.id)

##############
## Generate Teams

Team.destroy_all
UserTeam.destroy_all

team_locations = [
  'Crookesmore', 'The Diamond', 'Rotherham',
  'Sheffield City', 'Meadowhall'
]

team_name_suffixes = %w[
  Badgers Crooks Bears Marsupials Ligers Sloths
  Dragons Snakes Dholes Cockatrices Rodents
]

num_players = q_ur_players.count
num_managers = q_ur_managers.count

num_teams = (num_players / rand(8..12)).to_i
num_teams.times do
  loc = team_locations.sample
  team_name = if rand > 0.44
                "#{loc} #{team_name_suffixes.sample}"
              else
                team_name_suffixes.sample
              end

  team_manager = q_ur_managers.offset(rand(num_managers)).first.user

  Team.create(
    name: team_name,
    location_name: loc,
    owner_id: team_manager.id
  )
end

player_ids = q_ur_players.pluck :user_id

max_per_team = (num_players / (num_teams + 1)).clamp(1, 16)
min_per_team = [max_per_team / 2, 1].max
Team.find_each do |team|
  num_players = rand(min_per_team..max_per_team)

  num_players.times do
    player_id = player_ids.delete_at rand(player_ids.size)

    UserTeam.create(
      team_id: team.id,
      user_id: player_id,
      accepted: rand > 0.3
    )
  end
end

############

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
