# frozen_string_literal: true

# == Schema Information
#
# Table name: teams
#
#  id            :bigint           not null, primary key
#  location_name :string
#  name          :string
#  team_name     :string
#  url           :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  owner_id      :bigint
#
require 'rails_helper'

RSpec.describe Team do
  before do
    create(:user_team, user_id: player.id, accepted: true, team_id: team.id)
    create(:match, team_id: team.id, start_time: 'Thu, 02 May 2025 16:34:00.000000000 BST +01:00')
    create(:match, team_id: team.id, start_time: 'Fri, 03 May 2024 16:34:00.000000000 BST +01:00', goals_for: 2,
                   goals_against: 3)
    create(:match, team_id: team.id, start_time: 'Sat, 04 May 2024 16:34:00.000000000 BST +01:00', goals_for: 2,
                   goals_against: 1)
    create(:match, team_id: team.id, start_time: 'Sun, 05 May 2024 16:34:00.000000000 BST +01:00', goals_for: 0,
                   goals_against: 0)
    create(:match, team_id: team.id, start_time: 'Mon, 06 May 2024 16:34:00.000000000 BST +01:00', goals_for: 1,
                   goals_against: 3)
    create(:match, team_id: team.id, start_time: 'Tue, 07 May 2024 16:34:00.000000000 BST +01:00', goals_for: 2,
                   goals_against: 0)
  end

  let!(:player) { create(:user) }
  let!(:team) { create(:team, name: 'Sharks', owner: owner) }
  let!(:owner) { create(:user) }

  it 'is valid with valid attributes' do
    create(:user)
    team = build(:team)
    expect(team).to be_valid
  end

  it 'is not valid without a name' do
    create(:user)
    team = build(:team, name: nil)
    expect(team).not_to be_valid
  end

  describe '#played_count' do
    it 'shows how many matches have been played in the past' do
      expect(team.played_count).to eq 5
    end
  end

  describe '#win_count' do
    it 'shows how many matches team has won' do
      expect(team.win_count).to eq 2
    end
  end

  describe '#draw_count' do
    it 'shows how many matches team drew' do
      expect(team.draw_count).to eq 1
    end
  end

  describe '#loss_count' do
    it 'shows how many matches team has lost' do
      expect(team.loss_count).to eq 2
    end
  end

  describe '#days_until_next_match' do
    it 'shows how many days till next match' do
      date = Time.current
      future = Time.parse('2025-05-02 16:34:00 +01:00')
      days_left = (future.to_date - date.to_date).to_i
      expect(team.days_until_next_match).to eq days_left
    end
  end

  describe '#manager' do
    it 'retrieves the id of the owner of team' do
      expect(team.manager).to eq owner
    end
  end

  describe '#player_count' do
    it 'shows how many players are in team' do
      expect(team.player_count).to eq 1
    end
  end
end
