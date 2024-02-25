# frozen_string_literal: true

# Pages controller (probably won't survive)
class PagesController < ApplicationController
  before_action :redirect_if_authenticated
  skip_before_action :authenticate_user!

  def index; end

  private

  def redirect_if_authenticated
    redirect_to dashboard_path if user_signed_in?
  end
end
