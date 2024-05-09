class DropAdminReports < ActiveRecord::Migration[7.1]
  def change
    drop_table :admin_reports
  end
end
