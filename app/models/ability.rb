# frozen_string_literal: true

# Defines the ability for Users of different types across the app
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    can :manage, :admin_dashboard if user.decorate.site_admin?

    can :read, :all
  end
end
