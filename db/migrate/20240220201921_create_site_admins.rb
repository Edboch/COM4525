# frozen_string_literal: true

class CreateSiteAdmins < ActiveRecord::Migration[7.0]
  def change
    create_table :site_admins do |t|
      t.belongs_to :user, foreign_key: true, index: { unique: true }
    end
  end
end
