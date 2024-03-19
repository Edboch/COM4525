# frozen_string_literal: true

class AddTeamIdToMatches < ActiveRecord::Migration[7.0]
  def change
    remove_column :matches, :team_id
  end
end
