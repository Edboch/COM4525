# frozen_string_literal: true

class AddTeamRelationToInvites < ActiveRecord::Migration[7.1]
  def change
    add_reference :invites, :team, null: false, foreign_key: true
  end
end
