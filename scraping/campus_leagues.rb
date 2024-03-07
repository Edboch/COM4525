require 'httparty'
require 'nokogiri'

class CampusLeaguesScraper
  attr_accessor :league_url, :league

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

  URL_PREFIX = 'https://sportsheffield.sportpad.net/leagues'.freeze

  def initialize(input_url)
    @url_suffix = extract_league_url_suffix(input_url)
    @key_mapping = {
      'Team' => :name,
      'P' => :played,
      'W' => :wins,
      'D' => :draws,
      'L' => :losses,
      'GF' => :goals_for,
      'GA' => :goals_against,
      'GD' => :goal_difference,
      'Pts' => :points
    }
    @league = League.new(extract_teams_from_league)
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
    league_url = build_url('view')
    league_html = get_raw_html(league_url)
    table = league_html.css('table.division-table')

    teams = []
    headers = table.css('tr').first.css('th').map { |header| header.text.strip }
    table.css('tr')[1..].each do |row|
      row_data = row.css('td').map { |cell| cell.text.strip }
      row_hash = headers.zip(row_data).to_h { |header, value| [@key_mapping[header], value] }
      teams << Team.new(**row_hash)
    end
    teams
  end

  def extract_fixtures
    fixtures_url = build_url('fixtures')
    fixtures_html = get_raw_html(fixtures_url)
    puts fixtures_html
  end
end

# define team and league classes to hold data
class Team
  attr_accessor :name, :points, :wins, :draws, :losses, :goal_difference, :goals_for, :goals_against

  def initialize(name:, played: 0, points: 0, wins: 0, draws: 0, losses: 0, goal_difference: 0, goals_for: 0,
                 goals_against: 0)
    @name = name
    @played = played
    @points = points
    @wins = wins
    @draws = draws
    @losses = losses
    @goal_difference = goal_difference
    @goals_for = goals_for
    @goals_against = goals_against
  end

  def to_s
    "#{@name}: #{@points} points, Goal Difference: #{@goal_difference}"
  end
end

class League
  attr_accessor :teams

  def initialize(teams)
    @teams = teams
  end

  # need to fix this - doesn't rank correctly
  def display_table
    sorted_teams = @teams.sort_by { |team| [-team.points, -team.goal_difference, -team.goals_for, -team.goals_against] }
    sorted_teams.each_with_index do |team, index|
      puts "#{index + 1}. #{team}"
    end
  end
end

url = 'https://sportsheffield.sportpad.net/leagues/view/1497/86'
# url = 'https://sportsheffield.sportpad.net/leagues/view/1471/86'

cl_scraper = CampusLeaguesScraper.new(url)

cl_scraper.league.display_table
