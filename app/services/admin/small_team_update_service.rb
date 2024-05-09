
module Admin
  class SmallTeamUpdateService < ApplicationService
    include ServiceHelper

    def initialize(id, name, location_name, owner)
      @team = Team.find_by id: id
      if @team.nil?
        @valid = false
        @message = "No Team of ID #{id}"
        return
      end

      @owner = User.find_by id: owner
      if @owner.nil?
        @valid = false
        @message = "No User of ID #{id}"
        return
      end

      @name = name
      @location_name = location_name
      @valid = true
    end

    def call
      return failure(@message) unless @valid

      @team.name = @name
      @team.location_name = @location_name
      @team.owner = @owner

      result = @team.save
      return result ? success(result) : failure('Could not save team')
    end
  end
end
