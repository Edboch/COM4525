# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
roles = %w[Manager Player]
roles.each do |role_name|
  Role.find_or_create_by!(name: role_name)
end

User.destroy_all
SiteAdmin.destroy_all

sa_user = User.create email: 'site-admin@grr.la', password: 'password', name: 'Dominic Admin'
SiteAdmin.create user_id: sa_user.id

Player.create email: 'player@grr.la', password: 'password', name: 'Player Messi'

Manager.create email: 'manager@grr.la', password: 'password', name: 'John Manager'
