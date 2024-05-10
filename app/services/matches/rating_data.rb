# frozen_string_literal: true

module Matches
  # fetch the necessary data to display ratings in the matches views
  class RatingData
    def initialize(team, user, match)
      @team = team
      @user = user
      @match = match
    end

    def data
      if @user.staff_of_team?(@team)
        staff_data
      else
        player_data
      end
    end

    private

    def staff_data
      user_teams = UserTeam.where(team_id: @team.id, accepted: true)
      players = user_teams.map { |user_team| User.find_by(id: user_team.user_id) }
      options = [['N/A', -1]]
      (0..10).each { |v| options << [v, v] }
      [players, options, nil]
    end

    def player_data
      rating = @user.player_ratings.find_by(match: @match)&.rating
      rating = rating == -1 ? 'N/A' : rating || 'N/A'
      [nil, nil, rating]
    end
  end
end
