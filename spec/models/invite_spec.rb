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
require 'rails_helper'

RSpec.describe Invite do
  pending "add some examples to (or delete) #{__FILE__}"
end
