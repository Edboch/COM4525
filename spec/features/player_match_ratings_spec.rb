# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'player match ratings' do
  let!(:manager) { create(:user) }
  let!(:team) { create(:team) }
  let!(:player) { create(:user) }
  let!(:match) { create(:match, team: team) }

  before do
    create(:user_team, user: player, team: team, accepted: true)
    team.owner_id = manager.id
    team.save
  end

  context 'when manager goes to submit a rating' do
    before do
      login_as(manager, scope: :user)
      visit team_match_path(team, match)
    end

    it 'has the player on the page' do
      expect(page).to have_content(player.name)
    end

    it 'has the player\'s default rating set to N/A in the form' do
      expect(page).to have_select("player_ratings_#{player.id}", selected: 'N/A')
    end

    it 'is possible to click the submit button' do
      expect(page).to have_button('Submit Ratings')
    end
  end

  context 'when ratings are submitted logged in as a manager' do
    before do
      login_as(manager, scope: :user)
      visit team_match_path(team, match)

      select '7', from: "player_ratings_#{player.id}"
      click_on 'Submit Ratings'
    end

    it 'appears as the user\'s last rating' do
      player.reload
      expect(player.player_ratings.find_by(match: match).rating).to eq(7)
    end

    it 'displays a message that the rating has been updated successfully' do
      expect(page).to have_text('Ratings updated successfully')
    end

    it 'is autoloaded into the form after submission' do
      visit current_path
      expect(page).to have_select("player_ratings_#{player.id}", selected: '7')
    end
  end

  context 'when player rating submitted and player wants to view' do
    before do
      login_as(player, scope: :user)
      visit team_match_path(team, match)
    end

    it 'is visible to the player' do
      create(:player_rating, user: player, match: match, rating: 7)
      # reload the page
      visit current_path
      expect(page).to have_text('7')
    end

    it 'defaults to N/A' do
      expect(page).to have_text('N/A')
    end
  end
end
