require 'rails_helper'

RSpec.describe 'player match rating is submitted' do
  let!(:manager) { create(:user) }
  let!(:team) { create(:team) }
  let!(:player) { create(:user) }
  let!(:match) { create(:match, team: team) }

  before do
    # add manager and player to team
    create(:user_team, user: player, team: team, accepted: true)
    team.owner_id = manager.id
    team.save

    # manager log in
    login_as(manager, scope: :user)
    visit team_match_path(team, match)

    # submit rating
    select '8', from: "player_ratings_#{player.id}"
    click_on 'Submit Ratings'
  end

  it 'appears as the user\'s last rating' do
    expect(player.player_ratings.find_by(match: match).rating).to eq(8)
  end

  it 'displays a message that the rating has been updated successfully' do
    expect(page).to have_text('Ratings updated successfully')
  end
end

