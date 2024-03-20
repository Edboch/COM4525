# frozen_string_literal: true

module FrontendHelper
  FE_Member = Struct.new :id, :name, keyword_init: true
  FE_Location = Struct.new :name, keyword_init: true
  FE_Team = Struct.new :id, :name, :location, :manager, :players, keyword_init: true
end
