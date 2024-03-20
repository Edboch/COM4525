# frozen_string_literal: true

class RemoveUserRoles < ActiveRecord::Migration[7.1]
  def change
    drop_table :user_roles do |t|
      t.references :user, null: false, foreign_key: true
      t.references :role, null: false, foreign_key: true

      t.timestamps
    end

    drop_table :roles do |t|
      t.string :name

      t.timestamps
    end
  end
end
