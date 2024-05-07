# frozen_string_literal: true

# Decorator for User views
class UserDecorator < ApplicationDecorator
  delegate_all

  def admin?
    !object.site_admin.nil?
  end
end
