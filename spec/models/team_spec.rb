# frozen_string_literal: true

# == Schema Information
#
# Table name: teams
#
#  id            :bigint           not null, primary key
#  location_name :string
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  owner_id      :bigint
#
require 'rails_helper'

RSpec.describe Team do
  it 'is valid with valid attributes' do
    create(:user)
    team = build(:team)
    expect(team).to be_valid
  end

  it 'is not valid without a name' do
    create(:user)
    team = build(:team, name: nil)
    expect(team).not_to be_valid
  end
end
