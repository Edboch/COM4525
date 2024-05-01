# frozen_string_literal: true

# Updates the TeamActivity for today for all
# the teams that the provided user is a part of
#
# @param [User] user The user whose activity to log
class TeamActivityService < ApplicationService
  def initialize(user)
    @user = user
  end

  def call
    return failure('No user provided') if @user.nil?

    created_entries = 0
    today = Time.current.beginning_of_day

    @user.teams.each do |team|
      ta = TeamActivity.find_by team: team, day_start: today
      if ta.nil?
        ta = TeamActivity.new team: team, day_start: today
        created_entries += 1
      end

      ta.active_users += 1
      ta.save
    end

    success({ created_entries: created_entries })
  end
end
