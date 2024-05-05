# frozen_string_literal: true

module Scrapers
  # abstract interface all scrapers should follow
  class BaseScraper
    def initialize
      raise NotImplementedError, 'Init method must be initialised to check URL.'
    end

    def fetch_league
      raise NotImplementedError, 'fetch_league must be implmented by subclass.'
    end

    def fetch_fixtures
      raise NotImplementedError, 'fetch_fixtures must be implemented by subclass'
    end

    def fetch_results
      raise NotImplementedError, 'fetch_results must be implmented by subclass.'
    end
  end
end
