# frozen_string_literal: true

class AddUrlAndTeamNameToTeams < ActiveRecord::Migration[7.1]
  def change
    add_column :teams, :url, :string
    add_column :teams, :team_name, :string
  end
end
