# frozen_string_literal: true

class AddScoreToMatches < ActiveRecord::Migration[7.0]
  def change
    add_column :matches, :goals_for, :int
    add_column :matches, :goals_against, :int
  end
end
