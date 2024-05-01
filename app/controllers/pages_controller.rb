# frozen_string_literal: true

# Pages controller (probably won't survive)
class PagesController < ApplicationController
  include ApplicationHelper
  before_action :redirect_if_authenticated
  # before_action :fill_visitor

  def index; end

  private

  def redirect_if_authenticated
    redirect_to dashboard_path if user_signed_in?
  end
end
