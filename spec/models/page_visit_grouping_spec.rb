# frozen_string_literal: true

# == Schema Information
#
# Table name: page_visit_groupings
#
#  id           :bigint           not null, primary key
#  category     :string           not null
#  count        :integer          default(0), not null
#  period_start :datetime
#
require 'rails_helper'

RSpec.describe PageVisitGrouping do
  pending "add some examples to (or delete) #{__FILE__}"
end
