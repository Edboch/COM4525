# frozen_string_literal: true

module Admin
  # Updates the user and everything pertaining to them across the website
  class UpdateSiteUserService < ApplicationService
    def initialize(id, user)
      @user = User.find_by id: id
      if @user.nil?
        @valid = false
        @message = "No User of ID #{id}"
        return
      end

      @map = user
      @valid = true
    end

    def call
      return failure(@message) unless @valid

      result = UpdateUserService.call @user.id, @map[:name], @map[:email], @map[:is_admin]
      return failure(result[:error]) unless result[:success?]

      team_ids_from_req = @map[:teams].map { |team| team[:id] }
      kept_teams = @user.teams.filter { |t| team_ids_from_req.include? t.id }
      @user.teams = kept_teams

      @map[:teams].each do |t_json|
        next if @user.teams.exists? id: t_json[:id]

        ut = UserTeam.new user_id: @user.id, team_id: t_json[:id]
        ut.roles = TeamRole.where id: t_json[:roles]
        ut.save
      end
    end
  end
end
