# frozen_string_literal: true

# == Schema Information
#
# Table name: invites
#
#  id          :bigint           not null, primary key
#  description :text
#  location    :string
#  time        :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  team_id     :bigint           not null
#
# Indexes
#
#  index_invites_on_team_id  (team_id)
#
# Foreign Keys
#
#  fk_rails_...  (team_id => teams.id)
#
class Invite < ApplicationRecord
  belongs_to :team
end
