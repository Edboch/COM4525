class AddTypeToTeamRole < ActiveRecord::Migration[7.1]
  def change
    change_table :team_roles do |t|
      t.integer :type
    end
  end
end
