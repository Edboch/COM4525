# frozen_string_literal: true

# == Schema Information
#
# Table name: matches
#
#  id            :bigint           not null, primary key
#  goals_against :integer
#  goals_for     :integer
#  location      :string           not null
#  opposition    :string           not null
#  start_time    :datetime         not null
#  status        :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  team_id       :bigint           default(1), not null
#
# Indexes
#
#  index_matches_on_team_id  (team_id)
#
# Foreign Keys
#
#  fk_rails_...  (team_id => teams.id)
#
require 'rails_helper'
require 'spec_helper'

RSpec.describe Match do
  describe '#result' do
    let(:draw) { described_class.new(goals_for: 0, goals_against: 0) }
    let(:win) { described_class.new(goals_for: 2, goals_against: 1) }
    let(:loss) { described_class.new(goals_for: 0, goals_against: 1) }

    it 'retrieves the results as a draw' do
      print draw
      expect(draw.result).to eq 'draw'
    end

    it 'retrieves the results as a win' do
      expect(win.result).to eq 'win'
    end

    it 'retrieves the results as a loss' do
      expect(loss.result).to eq 'loss'
    end
  end

  describe '#scoreline' do
    it 'retrieves the score as a string' do
      match = described_class.new(goals_for: 0, goals_against: 0)
      expect(match.scoreline).to eq '0-0'
    end
  end
end
