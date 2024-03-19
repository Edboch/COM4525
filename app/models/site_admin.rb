# frozen_string_literal: true

# == Schema Information
#
# Table name: site_admins
#
#  id      :bigint           not null, primary key
#  user_id :bigint
#
# Indexes
#
#  index_site_admins_on_user_id  (user_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class SiteAdmin < ApplicationRecord
  belongs_to :user, inverse_of: :site_admin
end
