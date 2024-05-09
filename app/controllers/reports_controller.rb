# frozen_string_literal: true

# Controller for managing reports from users in the application
class ReportsController < ApplicationController
  before_action :authenticate_user!

  def show
    @report = current_report
  end

  def new
    @report = current_user.reports.build(solved: false)
  end

  def create
    @report = current_user.reports.build(report_params)
    @report.solved = false
    if @report.save
      redirect_back(fallback_location: root_path, notice: I18n.t('report.create.success'))
    else
      render :new
    end
  end

  def set_report_to_solved
    @report = current_report
    return unless @report.set_report_to_solved(report_params)

    redirect_to @report, notice: I18n.t('report.set_report_to_solved.success')
  end

  private

  def report_params
    params.require(:report).permit(:user_id, :content, :solved)
  end
end
