class PagesController < ApplicationController
  before_action :redirect_if_authenticated

  def index
  end

  private

  def redirect_if_authenticated
    redirect_to dashboard_path if user_signed_in?
  end

end