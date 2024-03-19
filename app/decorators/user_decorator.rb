# frozen_string_literal: true

# Decorator for User views
class UserDecorator < ApplicationDecorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end
  def site_admin?
    SiteAdmin.exists? user_id: object.id
  end

  def update_roles(role_string)
    user_role_update = lambda do |role_name, to_create|
      rp = Role.find_or_create_by! name: role_name
      if to_create
        UserRole.create user_id: object.id, role_id: rp.id
      else
        UserRole.destroy_by user_id: object.id, role_id: rp.id
      end
    end

    user_role_update.call('Player', role_string.include?('p')) if object.player? != role_string.include?('p')
    user_role_update.call('Manager', role_string.include?('m')) if object.manager? != role_string.include?('m')
    create_destroy_site_admin(role_string.include?('s')) if site_admin? != role_string.include?('s')
  end

  def create_destroy_site_admin(create)
    if create
      SiteAdmin.create user_id: object.id
    else
      SiteAdmin.destroy_by user_id: object.id
    end
  end
end
