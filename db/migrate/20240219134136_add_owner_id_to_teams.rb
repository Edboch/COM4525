# frozen_string_literal: true

class AddOwnerIdToTeams < ActiveRecord::Migration[7.0]
  def change
    add_column :teams, :owner_id, :bigint
  end
end
