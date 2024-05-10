# frozen_string_literal: true

module Matches
  # update player ratings for matches
  class RatingsUpdater
    def initialize(match, player_ratings)
      @match = match
      @player_ratings = player_ratings
    end

    def update_ratings
      ActiveRecord::Base.transaction do
        @player_ratings.each do |user_id, rating|
          PlayerRating.find_or_initialize_by(match: @match, user_id: user_id).update!(rating: rating)
        end
      end
    end
  end
end
