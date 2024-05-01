# frozen_string_literal: true

class CreateTeamActivities < ActiveRecord::Migration[7.1]
  def change
    create_table :team_activities do |t|
      t.references :team, null: false, foreign_key: true

      t.integer :active_users, null: false, default: 0
      t.datetime :day_start, null: false
    end
  end
end
