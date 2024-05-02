# frozen_string_literal: true

# == Schema Information
#
# Table name: player_ratings
#
#  id         :bigint           not null, primary key
#  rating     :integer          default(-1)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  match_id   :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_player_ratings_on_match_id  (match_id)
#  index_player_ratings_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (match_id => matches.id)
#  fk_rails_...  (user_id => users.id)
#
class PlayerRating < ApplicationRecord
  belongs_to :match
  belongs_to :user
end
