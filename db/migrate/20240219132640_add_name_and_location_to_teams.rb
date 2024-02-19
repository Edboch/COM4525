# frozen_string_literal: true

class AddNameAndLocationToTeams < ActiveRecord::Migration[7.0]
  def change
    add_column :teams, :name, :string
    add_column :teams, :location_name, :string
  end
end
