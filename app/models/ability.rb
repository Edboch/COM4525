# frozen_string_literal: true

# Defines the ability for Users of different types across the app
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    user.owned_teams.each do |team|
      manager_permissions(team)
    end

    user.teams.each do |team|
      player_permissions(team)
    end

    can :create, Team
    can :manage, :admin_dashboard unless user.site_admin.nil?
  end

  def manager_permissions(team)
    can :manage, Team, id: team.id
    can :manage, UserTeam, team_id: team.id
    can :manage, Match, team_id: team.id
    can :manage, Invite, team_id: team.id
    can :manage, MatchEvent, match: { team_id: team.id }
    can :manage, PlayerMatch
  end

  def player_permissions(team)
    can :read, Team, id: team.id
    can :player_stats, Team, id: team.id
    can :players, Team, id: team.id
    can :read, Match, team_id: team.id
    can :fixtures, Match, team_id: team.id
    can :read, MatchEvent, match: { team_id: team.id }
    can :read, PlayerMatch
    can :toggle_availability, Match, team_id: team.id
  end
end
