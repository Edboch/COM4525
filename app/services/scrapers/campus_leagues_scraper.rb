# frozen_string_literal: true

require 'httparty'
require 'nokogiri'

module Scrapers
  # scraper specific to campus leagues
  class CampusLeaguesScraper < BaseScraper
    KEY_MAPPING = {
      'Team' => :name,
      'P' => :played,
      'W' => :wins,
      'D' => :draws,
      'L' => :losses,
      'GF' => :goals_for,
      'GA' => :goals_against,
      'GD' => :goal_difference,
      'Pts' => :points
    }.freeze

    URL_PREFIX = 'https://sportsheffield.sportpad.net/leagues'

    attr_reader :url_suffix, :team_name

    def initialize(input_url, team_name)
      @url_suffix = extract_league_url_suffix(input_url)
      @team_name = team_name
    end

    def fetch_league
      @fetch_league ||= League.new(extract_teams_from_league)
    end

    def fetch_fixtures
      @fetch_fixtures ||= create_fixtures(extract_fixtures('fixtures'))
    end

    def fetch_results
      @fetch_results ||= create_fixtures(extract_fixtures('results'))
    end

    def extract_league_url_suffix(url)
      url_vars = url.match(%r{/(view|fixtures|results)/(\d+)/(\d+)})
      "#{url_vars[2]}/#{url_vars[3]}"
    end

    def get_raw_html(url)
      response = HTTParty.get(url)
      Nokogiri::HTML(response.body)
    end

    def build_url(url_type)
      "#{URL_PREFIX}/#{url_type}/#{@url_suffix}"
    end

    def extract_teams_from_league
      url = build_url('view')
      html = get_raw_html(url)
      table = html.css('table.division-table')

      teams = []
      headers = table.css('tr').first.css('th').map { |header| header.text.strip }
      table.css('tr')[1..].each do |row|
        row_data = row.css('td').map { |cell| cell.text.strip }
        row_hash = headers.zip(row_data).to_h { |header, value| [KEY_MAPPING[header], value] }
        teams << Team.new(row_hash)
      end
      teams
    end

    def extract_game(row, game_date)
      kickoff_time = Time.zone.parse(row.css('.new-row')[1].text.strip)
      kickoff_date = DateTime.new(game_date.year, game_date.month, game_date.day, kickoff_time.hour, kickoff_time.min)
      {
        team_a: extract_team_from_fixture(row, '.team-a'),
        team_b: extract_team_from_fixture(row, '.team-b'),
        score_a: extract_score_from_fixture(row, '.score', :first),
        score_b: extract_score_from_fixture(row, '.score', :last),
        kickoff: kickoff_date
      }
    end

    def extract_team_from_fixture(row, selector)
      row.at_css(selector).text.strip
    end

    def extract_score_from_fixture(row, selector, position)
      scores = row.css(selector).map(&:text).map(&:strip)
      position == :first ? scores.first : scores.last
    end

    def extract_fixtures(fixture_type)
      url = build_url(fixture_type)
      html = get_raw_html(url)
      current_date = nil
      results = []

      html.css('tr').each do |row|
        if row['class']&.include?('inner-header')
          current_date = Date.parse(row.text.strip)
        elsif row['id']
          results << extract_game(row, current_date)
        end
      end

      results
    end

    def create_fixtures(fixtures)
      fixtures.select { |fixture| fixture[:team_a] == @team_name || fixture[:team_b] == @team_name }
              .map { |fixture| TeamFixture.new(@team_name, fixture) }
    end

    def display_fixtures
      @fixtures.each do |fixture|
        puts fixture
      end
    end

    def display_results
      @results.each do |result|
        puts result
      end
    end
  end

  # holds data about a team
  class Team
    attr_accessor :name, :played, :points, :wins, :draws, :losses, :goal_difference, :goals_for, :goals_against

    def initialize(team_data)
      @name = team_data[:name]
      @played = team_data[:played].to_i
      @points = team_data[:points].to_i
      @wins = team_data[:wins].to_i
      @draws = team_data[:draws].to_i
      @losses = team_data[:losses].to_i
      @goal_difference = team_data[:goal_difference].to_i
      @goals_for = team_data[:goals_for].to_i
      @goals_against = team_data[:goals_against].to_i
    end

    def to_s
      "#{@name}: #{@points} points, Goal Difference: #{@goal_difference}"
    end
  end

  # holds fixture details
  class TeamFixture
    attr_accessor :opposition, :start_time, :goals_for, :goals_against, :location

    def initialize(team_name, match_hash)
      @team_name = team_name
      team_key = match_hash.key(@team_name)

      raise "Team name #{@team_name} not found in match hash." if team_key.nil?

      opposition_key = team_key == :team_a ? :team_b : :team_a
      score_key_for = team_key == :team_a ? :score_a : :score_b
      score_key_against = opposition_key == :team_a ? :score_a : :score_b

      @opposition = match_hash[opposition_key]
      @goals_for = match_hash[score_key_for].to_i || nil
      @goals_against = match_hash[score_key_against].to_i || nil
      @start_time = match_hash[:kickoff]
      @location = 'Unknown'
    end

    def to_json(_ = {})
      {
        opposition: @opposition,
        start_time: @start_time.strftime('%B %d, %Y %H:%M'),
        goals_for: @goals_for,
        goals_against: @goals_against,
        location: @location
      }.to_json
    end

    def to_s
      "#{@team_name} (#{@goals_for}) vs. #{@opposition} (#{@goals_against}) @ #{@kickoff}"
    end
  end

  # holds details about a football league
  class League
    attr_accessor :teams

    def initialize(teams)
      @teams = teams
    end

    def display_table
      sorted_teams = @teams.sort_by do |team|
        [-team.points, -team.goal_difference, -team.goals_for, team.goals_against]
      end
      sorted_teams.each_with_index do |team, index|
        puts "#{index + 1}. #{team}"
      end
    end
  end
end
