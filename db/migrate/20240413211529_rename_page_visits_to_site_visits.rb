class RenamePageVisitsToSiteVisits < ActiveRecord::Migration[7.1]
  def change
    rename_table :page_visits, :site_visits
    rename_table :page_visit_groupings, :site_visit_groupings
  end
end
