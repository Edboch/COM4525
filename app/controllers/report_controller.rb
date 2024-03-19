# frozen_string_literal: true

# Controller for managing users in the application
class ReportController < ApplicationController
    before_action :authenticate_user!
  
    def show
      @report = current_report
    end
  
    def destroy
      current_report.destroy
      redirect_to root_path, notice: I18n.t('report.destroy.success')
    end

    def report_params
      params.require(:report).permit(:user_id, :content)
    end
end