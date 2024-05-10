# frozen_string_literal: true

module Matches
  # update lineups for matches
  class LineupsUpdater
    def initialize(match, player_matches)
      @match = match
      @player_matches = player_matches
    end

    def update_lineup
      ActiveRecord::Base.transaction do
        @player_matches.each do |player_match_id, attributes|
          player_match = PlayerMatch.find(player_match_id)
          player_match.update!(position: PlayerMatch.positions[attributes[:position]])
        end
      end
    end
  end
end
