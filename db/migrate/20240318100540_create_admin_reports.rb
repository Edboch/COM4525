class CreateAdminReports < ActiveRecord::Migration[7.1]
  def change
    create_table :admin_reports do |t|
      t.belongs_to :user, null: false, foreign_key: true, index: { unique: true } 

      t.timestamps
    end
  end
end
