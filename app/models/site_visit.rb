# frozen_string_literal: true

# == Schema Information
#
# Table name: site_visits
#
#  id          :bigint           not null, primary key
#  visit_end   :datetime
#  visit_start :datetime
#
class SiteVisit < ApplicationRecord
end
