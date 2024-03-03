# frozen_string_literal: true

# Controller for the admin page
class AdminController < ApplicationController
  layout false
  before_action :check_access_rights

  ####################
  # GET

  def index; end

  ############
  # POST

  def retrieve_popularity_metrics
    response = { total: PageVisit.count, avgm: 0, avgw: 0 }
    render json: response
  end

  def retrieve_users
    # Target Query
    # SELECT users.id, users.email, users.type,
    #     CASE
    #       WHEN site_admins.user_id = users.id THEN true
    #       ELSE false
    #     END AS is_admin
    # FROM users
    # FULL JOIN site_admins ON users.id=site_admins.user_id;

    # The idea is that a user will only be assigned to the array of their
    # highest role
    # The arrays below are in ascending order
    players = []
    managers = []
    site_admins = []

    User.select(:id, :name, :email).decorate.each do |user|
      data = { id: user.id, name: user.name, email: user.email, roles: [] }
      array_flag = 0

      data[:roles].append('player') if user.player?
      if user.manager?
        data[:roles].append 'manager'
        array_flag = 1
      end
      if user.site_admin?
        data[:roles].append 'site-admin'
        array_flag = 2
      end

      case array_flag
      when 2
        site_admins.append data
      when 1
        managers.append data
      else
        players.append data
      end
    end

    response = { players: players, managers: managers, site_admins: site_admins }
    render json: response
  end

  def update_user
    user = User.find_by(id: params[:id]).decorate
    if user.nil?
      render json: { success: false, message: "Could not find user by ID #{params[:id]}" }
      return
    end

    user.name = params[:name]
    user.email = params[:email]
    user.update_roles params[:roles]
    result = user.save

    render json: { success: result }
  end

  def new_user
    # TODO: Send email with current password telling the user to update it

    user = User.create name: params[:name], email: params[:email], password: params[:password]
    user.decorate.update_roles params[:roles]

    render json: { success: true }
  end

  private

  ############
  # ACTIONS

  def check_access_rights
    # return if !user_signed_in? || !current_user.decorate.site_admin?
    # return if can? :manage, :admin_dashboard
    authorize! :manage, :admin_dashboard
    # redirect_to root_url
  end
end
