# frozen_string_literal: true

# Controller for managing the dashboard in the application
class DashboardController < ApplicationController
  include MetricsHelper

  before_action :fill_visitor

  def index; end

  private

  def fill_visitor
    @page_visit = find_page_visit
  end
end
