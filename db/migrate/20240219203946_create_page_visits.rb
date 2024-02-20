# frozen_string_literal: true

class CreatePageVisits < ActiveRecord::Migration[7.0]
  def change
    create_table :page_visits do |t|
      t.datetime :visit_start
      t.datetime :visit_end
    end
  end
end
