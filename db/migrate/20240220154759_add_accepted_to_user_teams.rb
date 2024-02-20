# frozen_string_literal: true

class AddAcceptedToUserTeams < ActiveRecord::Migration[7.0]
  def change
    add_column :user_teams, :accepted, :boolean, default: false
  end
end
