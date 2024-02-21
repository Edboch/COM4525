# frozen_string_literal: true

# Controller for the admin page
class AdminController < ApplicationController
  before_action :check_access_rights

  def index; end

  ############
  # ACTIONS

  def check_access_rights
    return if !user_signed_in? || !current_user.decorate.site_admin?

    redirect_to root_url
  end
end
