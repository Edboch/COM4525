# frozen_string_literal: true

# TODO: Docs
module Admin
  # Inserts a new user into the data base
  class NewTeamService < ApplicationService
    def initialize(location, team_name, owner_email)
      @team_name = team_name
      @location = location
      @owner_email = owner_email
    end

    def call
      return failure('No team name given') if @team_name.nil?
      return failure('Team Name is empty') if @team_name.empty?

      return failure('No location given') if @location.nil?
      return failure('Location is empty') if @location.empty?

      return failure('No owner email given') if @owner_email.nil?
      return failure('Owner Email is empty') if @owner_email.empty?

      user = User.find_by name: @owner_email
      return if user.nil?

      team = Team.create location_name: @team_name, name: @team_name, owner_id: user.id
      team.save
      success
    end
  end
end
