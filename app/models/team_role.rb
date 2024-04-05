# frozen_string_literal: true

# == Schema Information
#
# Table name: team_roles
#
#  id   :bigint           not null, primary key
#  name :string           not null
#  type :integer
#
class TeamRole < ApplicationRecord
  enum :type, { regular: 0, staff: 1 }

  # Disable STI
  self.inheritance_column = :_type_disabled

  # rubocop:disable Rails/HasAndBelongsToMany
  has_and_belongs_to_many :user_teams, join_table: 'user_team_roles'
  # rubocop:enable Rails/HasAndBelongsToMany
end
