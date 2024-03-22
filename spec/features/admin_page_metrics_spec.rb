# frozen_string_literal: true

require 'rails_helper'
require 'rake'

Rails.application.load_tasks

RSpec.describe 'Admin View Page Metrics' do
  # rubocop:disable RSpec/BeforeAfterAll
  before :all do
    create_list :page_visit, 100

    Rake::Task['page_visits:collate_visits'].invoke

    sleep 2
  end

  after :all do
    PageVisitGrouping.destroy_all
    PageVisit.destroy_all
  end
  # rubocop:enable RSpec/BeforeAfterAll

  before do
    sa = create :user, :site_admin

    visit '/'
    fill_in 'user[email]', with: sa.email
    fill_in 'user[password]', with: 'password'
    click_on 'Log in'
    click_on 'Admin'

    click_on 'General Stats'
  end

  specify 'The result for the past week is correct' do
    pweek = PageVisitGrouping.where(category: 'past week').first.count
    expect(find(:css, '#gnrl-popularity .pastw')).to have_content pweek.to_s
  end

  specify 'The result for the past month is correct' do
    pmonth = PageVisitGrouping.where(category: 'past month').first.count
    expect(find(:css, '#gnrl-popularity .pastm')).to have_content pmonth.to_s
  end

  specify 'The result for the past year is correct' do
    pyear = PageVisitGrouping.where(category: 'past year').first.count
    expect(find(:css, '#gnrl-popularity .pasty')).to have_content pyear.to_s
  end

  specify 'The result from a date range is correct', :js do
    from = (1.year.ago - 3.months).beginning_of_day
    til = (from + 6.months).beginning_of_day
    total = PageVisitGrouping.where(category: 'day').where(period_start: (from..til)).pluck(:count).sum

    within '#gnrl-pop-range' do
      fill_in 'start-date', with: from
      fill_in 'end-date', with: til
      click_on 'Send'

      sleep 0.2

      expect(find('.output')).to have_content total.to_s
    end
  end
end
