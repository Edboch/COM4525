# frozen_string_literal: true

module Admin
  # Routes for editing users as an admin
  class UsersController < ApplicationController
    include AdminHelper

    layout 'admin'
    before_action :check_access_rights

    def index

    end

    ###################
    ## POST

    def new
    end

    def update
    end

    def remove
    end
  end
end
