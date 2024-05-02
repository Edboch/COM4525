# frozen_string_literal: true

# Defines the ability for Users of different types across the app
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    can :manage, :admin_dashboard unless user.site_admin.nil?

    can :read, :all
  end
end
