# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Scrapers::ScraperFactory do
  describe '.create_scraper' do
    context 'when URL is valid' do
      let(:url) { 'https://sportsheffield.sportpad.net/leagues/view/1419/84' }
      let(:team_name) { 'test team' }
      let(:scraper) { described_class.create_scraper(url, team_name) }

      it 'returns a CampusLeaguesScraper' do
        expect(scraper).to be_a(Scrapers::CampusLeaguesScraper)
      end

      it 'has the correct url' do
        expect(scraper.url_suffix).to eq('1419/84')
      end

      it 'has the correct team name' do
        expect(scraper.team_name).to eq(team_name)
      end
    end

    context 'when URL is invalid' do
      let(:url) { 'https://example.com/leagues' }
      let(:team_name) { 'test team' }

      it 'raises NotImplementedError' do
        expect do
          described_class.create_scraper(url, team_name)
        end.to raise_error(NotImplementedError)
      end
    end
  end
end
