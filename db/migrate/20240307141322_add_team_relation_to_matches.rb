# frozen_string_literal: true

class AddTeamRelationToMatches < ActiveRecord::Migration[7.0]
  def change
    add_reference :matches, :team, null: false, foreign_key: true, default: 1
  end
end
