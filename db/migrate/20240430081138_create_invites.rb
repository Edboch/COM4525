# frozen_string_literal: true

class CreateInvites < ActiveRecord::Migration[7.1]
  def change
    create_table :invites do |t|
      t.bigint :team_id
      t.datetime :time
      t.string :location
      t.text :description

      t.timestamps
    end
  end
end
