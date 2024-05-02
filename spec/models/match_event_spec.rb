# == Schema Information
#
# Table name: match_events
#
#  id           :bigint           not null, primary key
#  event_minute :integer
#  event_type   :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  match_id     :bigint           not null
#  user_id      :bigint           not null
#
# Indexes
#
#  index_match_events_on_match_id  (match_id)
#  index_match_events_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (match_id => matches.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe MatchEvent, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
