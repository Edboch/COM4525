# frozen_string_literal: true

# == Schema Information
#
# Table name: page_visits
#
#  id          :bigint           not null, primary key
#  visit_end   :datetime
#  visit_start :datetime
#
FactoryBot.define do
  factory :page_visit do
    transient do
      min_start_date { 2.years.ago }
      max_start_date { 10.minutes.ago }
      min_time_elapsed { 1.minute }
      max_time_elapsed { 5.minutes }
    end

    visit_start { rand min_start_date..max_start_date }
    visit_end { visit_start + rand(min_time_elapsed..max_time_elapsed) }
  end
end
