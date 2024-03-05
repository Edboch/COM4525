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

User.destroy_all
SiteAdmin.destroy_all

############
# Known Users
# So we can log in is a specific role during development
sa_user = User.create email: 'site-admin@grr.la', password: 'password', name: 'Dominic Admin'
SiteAdmin.create user_id: sa_user.id

player = User.create email: 'player@grr.la', password: 'password', name: 'Player Messi'
UserRole.create user_id: player.id, role_id: role_player.id

manager = User.create email: 'manager@grr.la', password: 'password', name: 'John Manager'
UserRole.create user_id: manager.id, role_id: role_manager.id

#############
# Generated users

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

# TODO: Improve this by making use of the insert_all method
#       would probably be best to do once players and managers have dedicated tables
rand(35..60).times do
  email = email_usernames.sample + (rand > 0.3 ? rand(1...999_999).to_s : '')
  email += "@#{mail_servers.sample}.#{domain_names.sample}"
  pw = passwords.sample
  name = "#{firstnames.sample} #{surnames.sample}"

  roll = rand 100
  user = User.create email: email, password: pw, name: name

  if roll < 48
    UserRole.create user_id: user.id, role_id: role_player.id
  elsif roll < 98
    UserRole.create user_id: user.id, role_id: role_manager.id
  else
    SiteAdmin.create user_id: user.id
  end
end

############
# TODO: Generate page visits

date_start = 3.years.ago

rand(200..300).times do |_i|
  next_visit_time = rand(date_start..20.minutes.ago)
  rand(1..20).times do |_j|
    v_start = next_visit_time
    v_end = v_start + rand(0..5).minutes + rand(1..59).seconds
    PageVisit.create visit_start: v_start, visit_end: v_end
    break if v_end > Time.current
  end
end

Rake::Task['page_visits:collate_visits'].invoke
