# frozen_string_literal: true

# == Schema Information
#
# Table name: matches
#
#  id            :bigint           not null, primary key
#  goals_against :integer
#  goals_for     :integer
#  location      :string           not null
#  opposition    :string           not null
#  start_time    :datetime         not null
#  status        :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  team_id       :bigint           default(1), not null
#
# Indexes
#
#  index_matches_on_team_id  (team_id)
#
# Foreign Keys
#
#  fk_rails_...  (team_id => teams.id)
#
require 'rails_helper'

RSpec.describe Match do
  pending "add some examples to (or delete) #{__FILE__}"
end
