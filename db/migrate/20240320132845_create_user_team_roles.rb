class CreateUserTeamRoles < ActiveRecord::Migration[7.1]
  def change
    create_join_table(:user_teams, :team_roles,
                      table_name: :user_team_roles) do |t|
      # Not entirely sure this is necessary
      t.index :user_team_id
      t.index :team_role_id
    end
  end
end
