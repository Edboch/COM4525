# frozen_string_literal: true

# Defines the ability for Users of different types across the app
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    user.teams.each do |team|
      if user.owner_of_team?(team, user)
        # manager permissions
        can :manage, Team, team.id
      if user.player_of_team?(team)
        # player permissions
        can :read, Team, team.id
      end
    end

    can :manage, :admin_dashboard unless user.site_admin.nil?
  end
end
