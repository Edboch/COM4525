# frozen_string_literal: true

require 'rails_helper'
require 'rake'

Rails.application.load_tasks

RSpec.describe 'Admin View Site Metrics' do
  let!(:manager) { create(:user) }
  let!(:team) { create(:team) }
  # rubocop:disable RSpec/BeforeAfterAll
  before :all do
    create_list(:site_visit, 100)

    Rake::Task['site_visits:collate'].invoke

    sleep 2
  end

  after :all do
    SiteVisitGrouping.destroy_all
    SiteVisit.destroy_all
  end
  # rubocop:enable RSpec/BeforeAfterAll

  before do
    sa = create(:user, :site_admin)

    visit '/'
    fill_in 'user[email]', with: sa.email
    fill_in 'user[password]', with: 'password'
    click_on 'Log in'
    click_on 'Admin'

    click_on 'General Stats'
  end

  specify 'The result for the past week is correct' do
    pweek = SiteVisitGrouping.where(category: 'past week').first.count
    expect(find(:css, '#gnrl-popularity .pastw')).to have_content pweek.to_s
  end

  specify 'The result for the past month is correct' do
    pmonth = SiteVisitGrouping.where(category: 'past month').first.count
    expect(find(:css, '#gnrl-popularity .pastm')).to have_content pmonth.to_s
  end

  specify 'The result for the past year is correct' do
    pyear = SiteVisitGrouping.where(category: 'past year').first.count
    expect(find(:css, '#gnrl-popularity .pasty')).to have_content pyear.to_s
  end

  specify 'The result from a date range is correct', :js do
    from = (1.year.ago - 3.months).beginning_of_day
    til = (from + 6.months).beginning_of_day
    total = SiteVisitGrouping.where(category: 'day').where(period_start: (from..til)).pluck(:count).sum

    within '#gnrl-pop-range' do
      fill_in 'start-date', with: from
      fill_in 'end-date', with: til
      click_on 'Send'

      sleep 0.2

      expect(find('.output')).to have_content total.to_s
    end
  end
    specify 'The number of total public match invites is correct' do
      # Because we have not created any public match invite this should be 0 for now
      create(:invite, team_id: team.id)
      refresh
      sleep 0.2
      click_on 'General Stats'
      expect(find(:css, '#number_invites')).to have_content("1")
    end

  context 'when viewing team metrics' do
    before do
      create_list(:user, 20)
      create_list(:team, 3)

      days_back = 20
      while days_back > 0
        team = Team.offset(rand(Team.count)).first
        day_start = days_back.days.ago.beginning_of_day
        TeamActivity.create team: team, day_start: day_start, active_users: rand(team.users.size)

        days_back -= rand(1..3)
      end

      visit current_path
      click_on 'Teams'
    end

    specify 'I can see the number of teams' do
      num_teams = Team.count
      expect(find(:css, '#teams .statistic.num-teams')).to have_content num_teams
    end

    specify 'I can see the number of site vists per team' do
      visits_per_team = SiteVisit.count / Team.count
      expect(find(:css, '#teams .statistic.visits-per-team')).to have_content visits_per_team
    end

    specify 'I can see the number of active teams in the last two weeks' do
      recent_activities = TeamActivity.where('day_start > ?', 2.weeks.ago.beginning_of_day)
      num_teams_past_two_weeks = recent_activities.select(:team_id).distinct.count
      expect(find(:css, '#teams .statistic.team-activity')).to have_content num_teams_past_two_weeks
    end
  end
end
