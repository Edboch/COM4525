class CreatePlayerRatings < ActiveRecord::Migration[7.1]
  def change
    create_table :player_ratings do |t|
      t.references :match, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :rating, default: -1

      t.timestamps
    end
  end
end
