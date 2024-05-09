# frozen_string_literal: true

class SetDefaultForSolvedOnReports < ActiveRecord::Migration[7.1]
  def change
    change_column_default :reports, :solved, from: nil, to: false
  end
end
