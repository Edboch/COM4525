# frozen_string_literal: true

# Controller for managing users in the application
class ReportController < ApplicationController
  before_action :authenticate_user!

  def show
    @report = current_report
  end

  # def destroy
  # current_report.destroy
  # redirect_to root_path, notice: I18n.t('report.destroy.success')
  # end

  def set_report_to_solved
    @report = current_report
    return unless @report.set_report_to_solved(report_params)

    redirect_to @report, notice: I18n.t('report.set_report_to_solved.success')
  end

  def report_params
    params.require(:report).permit(:user_id, :content, :solved)
  end
end
