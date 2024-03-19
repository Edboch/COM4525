# frozen_string_literal: true

class CreateMatches < ActiveRecord::Migration[7.0]
  def change
    create_table :matches do |t|
      t.string :location, null: false
      t.string :opposition, null: false
      t.datetime :start_time, null: false
      t.string :status, null: false, status: 'upcoming'

      # match belongs to a team
      t.bigint :team_id, null: false

      t.timestamps
    end
  end
end
