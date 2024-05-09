# frozen_string_literal: true

# == Schema Information
#
# Table name: player_matches
#
#  id         :bigint           not null, primary key
#  available  :boolean          default(FALSE)
#  position   :integer          default("Goalkeeper")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  match_id   :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_player_matches_on_match_id  (match_id)
#  index_player_matches_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (match_id => matches.id)
#  fk_rails_...  (user_id => users.id)
#
class PlayerMatch < ApplicationRecord
  belongs_to :user
  belongs_to :match

  enum position: {
    Goalkeeper: 0,
    Defender: 1,
    Midfielder: 2,
    Forward: 3,
    Bench: 4,
    Reserve: 5
  }
end
