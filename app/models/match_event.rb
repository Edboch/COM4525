# frozen_string_literal: true

# == Schema Information
#
# Table name: match_events
#
#  id           :bigint           not null, primary key
#  event_minute :integer
#  event_type   :integer
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
class MatchEvent < ApplicationRecord
  belongs_to :match
  belongs_to :user

  enum event_type: {
    goal: 0,
    assist: 1,
    save_made: 2,
    foul: 3,
    yellow: 4,
    red: 5,
    goal_conceded: 6,
    penalty_won: 7,
    penalty_conceded: 8,
    offside: 9
  }

  validates :event_type, presence: true, inclusion: { in: event_types.keys }
  validates :event_minute, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
