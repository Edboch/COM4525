require 'rails_helper'
require 'spec_helper'

RSpec.describe "Performance testing" do
  include RSpec::Benchmark::Matchers

  let!(:site_admin) { create(:user, :site_admin)}
  let!(:manager1) { create(:user) }
  let!(:team) { create(:team, owner_id: manager1.id) }

  it 'loads team fixture page with 1000 matches' do
    create_list(:match, 10, team: team)
    login_as(manager1,scope: :user)
    visit dashboard_path

    expect {
      visit team_fixtures_path(team.id)
    }.to perform_under(100).ms
  end

  it 'loads admin page with 1000 users' do
    create_list(:user, 10)
    login_as(site_admin,scope: :user)
    visit dashboard_path
    
    expect {
      click_on 'Admin'
    }.to perform_under(100).ms
  end

  it 'loads admin page with 1000 teams' do
    create_list(:team, 10)
    login_as(site_admin,scope: :user)
    visit dashboard_path
    
    expect {
      click_on 'Admin'
    }.to perform_under(100).ms
  end

  it 'loads published invites page with 1000 invites' do
    create_list(:invite, 10, team_id:team.id)
    login_as(manager1,scope: :user)
    visit dashboard_path
    
    expect {
      visit team_published_invites_path(team.id)
    }.to perform_under(100).ms
  end

  it 'updates league table' do
    login_as(manager1,scope: :user)
    visit dashboard_path
    click_on 'View Team'
    click_on 'Edit Team'
    fill_in 'team_url', with: 'https://sportsheffield.sportpad.net/leagues/view/1471/86'
    fill_in 'team_team_name', with: 'CompSoc Greens'
    expect {
      click_on 'Update'
    }.to perform_under(100).ms
  end

  
end 