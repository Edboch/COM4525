# frozen_string_literal: true

module Admin
  # Routes for editing users as an admin
  class UsersController < ApplicationController
    include AdminHelper

    layout 'admin'
    before_action :check_access_rights
    before_action :populate_user, only: :show

    def show
      @js_teams = Team.all.to_json
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
