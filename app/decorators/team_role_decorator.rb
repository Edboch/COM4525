# frozen_string_literal: true

class TeamRoleDecorator < ApplicationDecorator
  delegate_all

  def type_name
    return 'Regular' if regular?
    return 'Staff' if staff?
    return 'Managerial' if managerial?
  end
end
