# frozen_string_literal: true

module Admin
  # Routes for the teams on the admin page
  class TeamsController < ApplicationController
    include AdminHelper

    layout 'admin'
    before_action :check_access_rights
    before_action :populate_team, only: :show

    def show
      @js_users = User.select(:id, :name, :email).to_json
      @js_roles = TeamRole.all.to_json
      json_members = @team.user_teams.includes([:user]).map do |ut|
        "#{ut.user.id}: { name: \"#{ut.user.name}\", email: '#{ut.user.email}', roles: #{ut.roles.pluck(:id)} }"
      end

      @js_team_members = "{ #{json_members.join(', ')} }"
    end

    ###################
    ## POST

    def update
      result = Admin::TeamUpdateService.call params[:team_id], params[:team]
      render json: result.to_json
    end

    def destroy
      team = Team.find_by id: params[:team_id]
      name = team.name
      team.destroy
      redirect_to admin_index_path(current_user), notice: "Team '#{name}' successfully deleted"
    end

    def small_update
      result = Admin::SmallTeamUpdateService.call params[:team_id], params[:name], params[:location_name],
                                                  params[:owner_id]
      render json: result.to_json
    end

    private

    def populate_team
      @team = Team.find_by id: params[:id]
    end
  end
end
