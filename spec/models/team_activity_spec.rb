# == Schema Information
#
# Table name: team_activities
#
#  id           :bigint           not null, primary key
#  active_users :integer          default(0), not null
#  day_start    :datetime         not null
#  team_id      :bigint           not null
#
# Indexes
#
#  index_team_activities_on_team_id  (team_id)
#
# Foreign Keys
#
#  fk_rails_...  (team_id => teams.id)
#
require 'rails_helper'

RSpec.describe TeamActivity, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
