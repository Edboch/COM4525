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
require 'rails_helper'

RSpec.describe SiteAdmin do
  pending "add some examples to (or delete) #{__FILE__}"
end
