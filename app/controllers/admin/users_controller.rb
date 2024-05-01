# frozen_string_literal: true

module Admin
  # Routes for editing users as an admin
  class UsersController < ApplicationController
    include AdminHelper

    layout 'admin'
    before_action :check_access_rights
    before_action :populate_user, only: :show

    def show
      @js_teams = Team.select(:id, :name, :location_name).to_json
      @js_roles = TeamRole.all.to_json
      @teams = (@user.owned_teams + @user.teams).uniq
      teams = @teams.map do |team|
          uts = @user.user_teams.where team: team

          "#{team.id}: { name: '#{team.name}', location_name: '#{team.location_name}',"\
            "roles: #{uts.includes(:roles).pluck('team_roles.id').to_json} }"
      end
      @js_my_teams = "{ #{teams.join(',')} }"

    end

    ###################
    ## POST

    def new
    end

    def update
    end

    def remove
    end

    private

    def populate_user
      @user = User.find_by(id: params[:id]).decorate
    end
  end
end
