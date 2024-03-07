# frozen_string_literal: true

require 'rails_helper'
require 'rake'

Rails.application.load_tasks

RSpec.describe 'Admin View Page Metrics' do
  let!(:site_admin) do
    sa = User.create email: 'the@eggman.com', password: 'password', name: 'Ivo Robotnik'
    SiteAdmin.create user_id: sa.id
    sa
  end

  before :all do
    100.times do |_i|
      v_start = rand(2.years.ago..1.minutes.ago)
      v_end = rand(v_start..([ 1.minutes.ago, v_start + rand(6).minutes ].min))
      PageVisit.create visit_start: v_start, visit_end: v_end
    end

    Rake::Task['page_visits:collate_visits'].invoke

    sleep 2

    @sa = User.create email: 'the@eggman.com', password: 'password', name: 'Ivo Robotnik'
    SiteAdmin.create user_id: @sa.id
  end

  before do
    visit '/'
    fill_in 'user[email]', with: @sa.email
    fill_in 'user[password]', with: 'password'
    click_on 'Log in'
    click_on 'Admin'

    click_on 'General Stats'
  end

  after :all do
    @sa.destroy

    PageVisitGrouping.destroy_all
    PageVisit.destroy_all
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

  specify '', js: true do
    from = 1.year.ago - 3.months
    til = from + 6.months
    total = PageVisitGrouping.where(category: 'day').where(period_start: (from..til)).pluck(:count).sum

    within find('#gnrl-pop-range') do
      fill_in 'start-date', with: from
      fill_in 'end-date', with: til
      click_on 'Send'

      sleep 0.2

      expect(find('.output')).to have_content total.to_s
    end
  end
end
