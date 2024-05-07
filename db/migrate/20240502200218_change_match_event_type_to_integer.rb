# frozen_string_literal: true

class ChangeMatchEventTypeToInteger < ActiveRecord::Migration[7.1]
  def change
    change_column :match_events, :event_type, 'integer USING CAST(event_type AS integer)'
  end
end
