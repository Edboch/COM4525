# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  name                   :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
require 'rails_helper'
require 'spec_helper'

RSpec.describe User do
  describe 'user match events' do
    let!(:user) { create(:user) }
    let!(:team) { create(:team) }
    let!(:match) { create(:match, team: team) }

    before do
      create(:user_team, team: team, user: user, accepted: true)

      events = [
        { event_type: 'goal', num: 2 },
        { event_type: 'assist', num: 0 },
        { event_type: 'save_made', num: 3 },
        { event_type: 'foul', num: 3 },
        { event_type: 'yellow', num: 3 },
        { event_type: 'red', num: 1 },
        { event_type: 'goal_conceded', num: 1 },
        { event_type: 'penalty_won', num: 2 },
        { event_type: 'penalty_conceded', num: 1 },
        { event_type: 'offside', num: 3 }
      ]

      events.each do |event|
        event[:num].times do
          create(:match_event, match: match, user: user, event_type: event[:event_type])
        end
      end
    end

    it 'calculates goals scored for team correctly' do
      puts user.goals_scored_for_team(team)
      puts user.teams
      puts user.match_events
      expect(user.goals_scored_for_team(team)).to eq(2)
    end

    it 'calculates assists for team correctly' do
      expect(user.assists_for_team(team)).to eq(0)
    end

    it 'calculates saves made for team correctly' do
      expect(user.saves_made_for_team(team)).to eq(3)
    end

    it 'calculates fouls for team correctly' do
      expect(user.fouls_for_team(team)).to eq(3)
    end

    it 'calculates yellows cards for team correctly' do
      expect(user.yellows_for_team(team)).to eq(3)
    end

    it 'calculates red cards for team correctly' do
      expect(user.reds_for_team(team)).to eq(1)
    end

    it 'calculates goals conceded for team correctly' do
      expect(user.goals_conceded_for_team(team)).to eq(1)
    end

    it 'calculates penalties won for team correctly' do
      expect(user.penalties_won_for_team(team)).to eq(2)
    end

    it 'calculates penalties conceded for team correctly' do
      expect(user.penalties_conceded_for_team(team)).to eq(1)
    end

    it 'calculates offsides for team correctly' do
      expect(user.offside_for_team(team)).to eq(3)
    end
  end
end
