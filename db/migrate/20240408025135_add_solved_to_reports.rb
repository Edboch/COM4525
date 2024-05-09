# frozen_string_literal: true

class AddSolvedToReports < ActiveRecord::Migration[7.1]
  def change
    add_column :reports, :solved, :boolean
  end
end
