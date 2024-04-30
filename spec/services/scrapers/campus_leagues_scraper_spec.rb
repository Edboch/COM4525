require 'rails_helper'

RSpec.describe Scrapers::CampusLeaguesScraper do
  describe '#fetch_league' do
    let(:url) { 'https://sportsheffield.sportpad.net/leagues/view/1419/84' }
    let(:scraper) { described_class.new(url, 'CompSoc Greens') }

    before do
      html_response = Rails.root.join('spec/data/league.html')
      stub_request(:get, url).to_return(body: html_response, status: 200)
    end

    it 'gets the correct first team in the league' do
      league = scraper.fetch_league
      expect(league.teams.first.name).to eq('EdBram FC')
    end

    it 'gets the correct number of points for league winner' do
      league = scraper.fetch_league
      expect(league.teams.first.points).to eq(25)
    end

    it 'gets the correct number of points for league loser' do
      league = scraper.fetch_league
      expect(league.teams.last.points).to eq(5)
    end

    it 'gets the correct last team in the league' do
      league = scraper.fetch_league
      expect(league.teams.last.name).to eq('Timor Leste FC')
    end

    it 'gets the correct number of teams' do
      league = scraper.fetch_league
      expect(league.teams.length).to eq(6)
    end
  end

  describe '#fetch_results' do
    let(:url) { 'https://sportsheffield.sportpad.net/leagues/results/1419/84' }
    let(:scraper) { described_class.new(url, 'CompSoc Greens') }

    before do
      html_response = Rails.root.join('spec/data/results.html')
      stub_request(:get, url).to_return(body: html_response, status: 200)
    end

    it 'gets the first result opposition correct' do
      results = scraper.fetch_results
      first_result = results.first
      expect(first_result.opposition).to eq('History FC')
    end

    it 'gets the first result goals_for correct' do
      results = scraper.fetch_results
      first_result = results.first
      expect(first_result.goals_for).to eq(2)
    end

    it 'gets the first result goals_against correct' do
      results = scraper.fetch_results
      first_result = results.first
      expect(first_result.goals_against).to eq(4)
    end

    it 'gets the first result location correct' do
      results = scraper.fetch_results
      first_result = results.first
      expect(first_result.location).to eq('Unknown')
    end

    it 'gets the correct number of results' do
      results = scraper.fetch_results
      expect(results.length).to eq(10)
    end
  end
end
