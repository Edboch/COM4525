require 'httparty'
require 'nokogiri'

url = 'https://sportsheffield.sportpad.net/leagues/view/1497/86'
url = 'https://sportsheffield.sportpad.net/leagues/view/1471/86'

response = HTTParty.get(url)
document = Nokogiri::HTML(response.body)

# init table data
table_data = []

# find league table
table = document.css('table.division-table')

# add headers
headers = table.css('tr').first.css('th').map { |header| header.text.strip }
table_data << headers

# get other row data and add to table data
table.css('tr')[1..].each do |row|
  row_data = row.css('td').map { |cell| cell.text.strip }
  table_data << row_data
end

# display table
table_data.each do |row|
  puts row.join(', ')
end

# how do I want to structure everything?

# each team can have an object within the league

# the league can also have its own object containing all teams

# need an object for a fixture - can optionally hold a score

# this can be generalised at first and then specific methods can be made for each site
