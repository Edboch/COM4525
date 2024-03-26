# frozen_string_literal: true

class CreatePageVisitGroupings < ActiveRecord::Migration[7.1]
  def change
    create_table :page_visit_groupings do |t|
      t.string :category, null: false
      t.integer :count, null: false, default: 0
      t.datetime :period_start, null: true
    end
  end
end
