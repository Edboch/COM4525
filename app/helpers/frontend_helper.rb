# frozen_string_literal: true

# Provides structs and functions to help with passing data
# to HAML files
module FrontendHelper
  FE_Member = Struct.new :id, :name, keyword_init: true
  FE_Location = Struct.new :name, keyword_init: true
  FE_Team = Struct.new :id, :name, :location, :manager, :players, keyword_init: true

  FE_User = Struct.new :id, :name, :email, :is_admin, keyword_init: true

  # TODO: Figure out how to decorate ActiveRecord::Associations::CollectionProxy
  #       and ActiveRecord::Calculations and move this there
  def get_fe_users(query)
    query.pluck(:id, :name, :email)
         .map do |user|
           is_admin = !SiteAdmin.find_by(user_id: user[0]).nil?
           logger.info user
           FE_User.new(id: user[0], name: user[1],
                       email: user[2], is_admin: is_admin)
         end
  end
end
