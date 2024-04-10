# frozen_string_literal: true

# TODO: Docs
module Admin
  # Inserts a new user into the data base
  class NewUserService < ApplicationService
    def initialize(name, email, password, site_admin)
      @name = name
      @email = email
      @password = password
      @site_admin = !site_admin.nil? && site_admin.to_b
    end

    def call
      return failure('No name given') if @name.nil?
      return failure('Name is empty') if @name.empty?

      return failure('No email given') if @email.nil?
      return failure('Email is empty') if @email.empty?

      return failure('No password given') if @password.nil?
      return failure('Password is empty') if @password.empty?

      # TODO: Email and password format checks?

      # TODO: Send email with current password telling the user to update it

      user = User.create name: @name, email: @email, password: @password
      user.site_admin = SiteAdmin.new if @site_admin
      success
    end
  end
end
