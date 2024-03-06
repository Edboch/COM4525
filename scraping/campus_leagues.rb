require 'httparty'
require 'nokogiri'

class CampusLeaguesScraper
  attr_accessor :league_url, :league

  def initialize(league_url)
    @league_url = league_url
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

  def get_raw_html(url)
    response = HTTParty.get(url)
    Nokogiri::HTML(response.body)
  end

  def extract_teams_from_league
    league_html = get_raw_html(@league_url)
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

  def display_table
    sorted_teams = @teams.sort_by { |team| [-team.points, -team.goal_difference, -team.goals_for, -team.goals_against] }
    sorted_teams.each_with_index do |team, index|
      puts "#{index + 1}. #{team}"
    end
  end
end

# url = 'https://sportsheffield.sportpad.net/leagues/view/1497/86'
url = 'https://sportsheffield.sportpad.net/leagues/view/1471/86'

cl_scraper = CampusLeaguesScraper.new(url)

cl_scraper.league.display_table
