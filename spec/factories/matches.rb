# frozen_string_literal: true

FactoryBot.define do
  factory :match do
    team
    goals_for { 2 }
    goals_against { 1 }
    location { 'Some Location' }
    opposition { 'Some Opposition' }
    start_time { Time.zone.now }
    status { 'Some Status' }
  end
end
