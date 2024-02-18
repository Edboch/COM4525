# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    def initialize(user)
      user ||= User.new # guest user (not logged in)
  
      if user.admin?
        can :manage, User
      else
        can :read, :all
      end
    end
  end
end
