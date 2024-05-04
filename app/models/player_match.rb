# frozen_string_literal: true

# A join table linking users to the match, acting as
# a lineup / availability table
class PlayerMatch < ApplicationRecord
  belongs_to :user
  belongs_to :match

  enum position: {
    bench: 0,
    goalkeeper: 1,
    defender: 2,
    midfielder: 3,
    forward: 4
  }
end
