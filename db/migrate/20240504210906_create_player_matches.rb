# frozen_string_literal: true

class CreatePlayerMatches < ActiveRecord::Migration[7.1]
  def change
    create_table :player_matches do |t|
      t.references :user, null: false, foreign_key: true
      t.references :match, null: false, foreign_key: true
      t.integer :position, default: 0
      t.boolean :available, default: false

      t.timestamps
    end
  end
end
