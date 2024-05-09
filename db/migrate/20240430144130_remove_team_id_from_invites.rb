# frozen_string_literal: true

class RemoveTeamIdFromInvites < ActiveRecord::Migration[7.1]
  def change
    remove_column :invites, :team_id, :bigint
  end
end
