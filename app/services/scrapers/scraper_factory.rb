# frozen_string_literal: true

module Scrapers
  # factory for scraper objects
  class ScraperFactory
    def self.create_scraper(url, team_name)
      raise NotImplementedError, 'No scraper exists for this URL.' unless url.include?('sportsheffield.sportpad.net')

      CampusLeaguesScraper.new(url, team_name)
    end
  end
end
