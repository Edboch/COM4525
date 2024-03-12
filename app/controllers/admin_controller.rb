# frozen_string_literal: true

# Controller for the admin page
class AdminController < ApplicationController
  layout false
  before_action :check_access_rights

  ####################
  # GET

  def index
    @users = user_data
  end

  ############
  # POST

  def retrieve_popularity_metrics
    response = { total: PageVisit.count, avgm: 0, avgw: 0 }
    render json: response
  end

  def retrieve_users
    response = user_data
    render json: response
  end

  def update_user
    user = User.find_by id: params[:id]
    return if user.nil?

    user.name = params[:name]
    user.email = params[:email]

    # TODO: Remeber to remove/add the site admin role when changing user roles

    result = user.save
    render json: { success: result }
  end

  private

  def user_data
    # Rather than returning separate arrays of the different types, we'll
    # do the sorting in the SQL query, which will be configurable by url params
    # TODO: Implement sorting options

    # Target Query
    # SELECT subq.id, subq.name, subq.email, array_agg(subq.role_name order by subq.role_name desc) AS roles
    # FROM
    #   ( SELECT users.id, users.name, users.email,
    #       CASE
    #         WHEN roles.name='Site Admin' THEN 2
    #         WHEN roles.name='Manager' THEN 1
    #         ELSE 0
    #       END AS role_name
    #     FROM user_roles
    #     LEFT OUTER JOIN users ON users.id=user_roles.user_id
    #     LEFT OUTER JOIN roles ON user_roles.role_id=roles.id
    #     ORDER BY users.id
    #   ) AS subq
    # GROUP BY subq.id, subq.name, subq.email
    # ORDER BY roles;
    player = 0
    manager = 1
    site_admin = 2

    subq = UserRole.select('users.id', 'users.name', 'users.email')
                   .select(%(
                           CASE
                            WHEN roles.name='Site Admin' THEN #{site_admin}
                            WHEN roles.name='Manager' THEN #{manager}
                            ELSE #{player}
                           END AS role_enum
                   ))
                   .left_outer_joins(:user).left_outer_joins(:role)
                   .order('users.id')
    query = UserRole.from(subq, :subq)
                    .select('subq.id', 'subq.name', 'subq.email')
                    .select('JSON_AGG(subq.role_enum ORDER BY subq.role_enum DESC)::TEXT as roles')
                    .group('subq.id', 'subq.name', 'subq.email')
                    .order('roles')

    query.all.map do |user|
      roles = JSON.parse(user.roles).map do |role_enum|
        case role_enum
        when site_admin
          'site-admin'
        when manager
          'manager'
        else
          'player'
        end
      end
      {
        id: user.id, name: user.name, email: user.email,
        roles: roles
      }
    end
  end

  ############
  # ACTIONS

  def check_access_rights
    # return if !user_signed_in? || !current_user.decorate.site_admin?
    # return if can? :manage, :admin_dashboard
    authorize! :manage, :admin_dashboard
    # redirect_to root_url
  end
end
