class CreateReports < ActiveRecord::Migration[7.1]
  def change
    create_table :reports do |t|
      t.bigint :user_id
      t.text :content

      t.timestamps
    end
  end
end
