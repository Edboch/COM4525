# frozen_string_literal: true

class CreateMatchEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :match_events do |t|
      t.references :match, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :event_type
      t.integer :event_minute

      t.timestamps
    end
  end
end
