# frozen_string_literal: true

# A collection of helper functions located here so the admin
# controller doesn't get too bloated
module AdminHelper
  include FrontendHelper

  # Collates the user teams into an array of structs
  #
  # @return [Array<Hash>] The teams
  #   @option return [Integer] :id The id of the team
  #   @option return [String]  :name The name of the team
  #   @option return [Hash]    :location The location information
  #     @option :location [String] :name The name of the location
  #   @option return [Hash]    :manager The team manager's information
  #     @option :manager [Integer] :id The id of the manager
  #     @option :manager [String]  :name The manager's name
  #   @option return [Array<Hash>] :players An array of the players in this team
  #     @option :players[] [Integer] :id   The player's id
  #     @option :players[] [String]  :name The player's name
  def user_teams
    Team.select(:id, :name, :location_name, :owner_id)
        .includes(:users).map do |team|
          r_mngr = User.find_by(id: team.owner_id)
          manager = FE_Member.new id: r_mngr.id, name: r_mngr.name

          players = team.users.pluck(:id, :name)
                        .map { |u| FE_Member.new id: u[0], name: u[1] }

          FE_Team.new(id: team.id,
                      name: team.name,
                      location: FE_Location.new(name: team.location_name),
                      manager: manager,
                      players: players)
        end
  end

  # Pulls all the users that have the role passed in and collates them
  # into a JavaScript array, with their id, name and email
  #
  # @param [String] role_name The name of the role we want to search by
  #
  # @return [String] A JS array of all the users with the role
  def js_user_role(role_name)
    raw = User.includes(:roles)
              .where(roles: { name: role_name })
              .pluck(:id, :name, :email)
              .map { |p| { id: p[0], name: p[1], email: p[2] } }

    sanitise_string = lambda do |str|
      cs = []
      str.chars.each do |c|
        cs << '\\' if c == "'"
        cs << c
      end
      cs.join
    end

    as_strings = raw.map do |p|
      "{ id: #{p[:id]}, name: '#{sanitise_string.call p[:name]}', " \
        "email: '#{sanitise_string.call p[:email]}' }"
    end
    "[ #{as_strings.join(', ')} ]"
  end
end
