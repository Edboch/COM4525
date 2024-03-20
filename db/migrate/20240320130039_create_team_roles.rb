# frozen_string_literal: true

class CreateTeamRoles < ActiveRecord::Migration[7.1]
  def change
    create_table :team_roles do |t|
      t.string :name, null: false
    end
  end
end
