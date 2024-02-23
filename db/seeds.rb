# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

User.destroy_all
SiteAdmin.destroy_all

############
# Known Users
# So we can log in is a specific role during development
sa_user = User.create email: 'site@admin.com', password: 'password', name: 'Dominic Admin'
SiteAdmin.create user_id: sa_user.id

Player.create email: 'reg@player.com', password: 'password', name: 'Player Messi'

Manager.create email: 'man@manager.com', password: 'password', name: 'John Manager'

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

firstnames = [
  'Michael', 'Matthew', 'Mark', 'Luke', 'John', 'Paul', 'Patrick',
  'Rebecca','Jennifer', 'Amy', 'Jemima', 'Isabelle'
]

surnames = [
  'Smith', 'Cook', 'Xixiang', 'Allen', 'Bateman',
  'Green', 'Repuga'
]

# TODO: Improve this by making use of the insert_all method
#       would probably be best to do once players and managers have dedicated tables
rand(35..60).times do
  email = email_usernames.sample + (rand > 0.3 ? rand(1...999_999).to_s : '')
  email += "@#{mail_servers.sample}.#{domain_names.sample}"
  pw = passwords.sample
  name = "#{firstnames.sample} #{surnames.sample}"

  roll = rand 100
  if roll < 48
    Player.create email: email, password: pw, name: name
  elsif roll < 98
    Manager.create email: email, password: pw, name: name
  else
    sa = User.create email: email, password: pw, name: name
    SiteAdmin.create user_id: sa.id
  end
end

############
# TODO: Generate page visits

