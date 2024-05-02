# frozen_string_literal: true

class DropLandingTables < ActiveRecord::Migration[7.1]
  def change
    drop_table :like_answers
    drop_table :like_reviews
    drop_table :reviews
    drop_table :landing_page_views
    drop_table :landing_visitor_locations
    drop_table :landing_pages
    drop_table :landing_users
    drop_table :question_answers
  end
end
