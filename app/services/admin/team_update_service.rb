# frozen_string_literal: true

module Admin
  # Service for updating everything in a team
  class TeamUpdateService < ApplicationService
    include ServiceHelper

    def initialize(id, team)
      @team = Team.find_by id: id
      if @team.nil?
        @valid = false
        @message = "No Team of ID #{id}"
        return
      end

      @data = team
      @valid = true
    end

    def call
      return failure(@message) unless @valid

      result = SmallTeamUpdateService.call @team.id, @data[:name], @data[:location][:name], @data[:owner][:id]
      return failure(result[:error]) unless result[:success?]

      user_ids_from_req = @data[:members].keys
      kept_members = @team.users.filter { |u| user_ids_from_req.include? u.id }
      @team.users = kept_members

      kept_members.each do |m|
        ut = UserTeam.find_by team: @team, user: m
        req = @data[:members][m.id]

        ut.roles = TeamRole.find_by id: req[:roles]
        ut.save
      end

      @data[:members].each do |id, member|
        next if @team.users.exists? id: id

        ut = UserTeam.new team: @team, user_id: id
        ut.roles = TeamRole.where id: member[:roles]
        ut.save
      end

      success
    end
  end
end
