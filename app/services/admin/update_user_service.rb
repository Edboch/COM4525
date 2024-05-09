# frozen_string_literal: true

module Admin
  # Updates the user pointed to by id
  class UpdateUserService < ApplicationService
    include ServiceHelper

    def initialize(id, name, email, is_admin)
      @user = User.find_by id: id
      if @user.nil?
        @valid = false
        @message = "No User of ID #{id}"
        return
      end

      @name = name
      @email = email
      @is_admin = is_admin.in?([true, false]) ? is_admin : (is_admin.nil? || is_admin.to_b)
      @valid = true
    end

    def call
      return failure(@message) unless @valid

      @user.name = @name
      @user.email = @email

      if @is_admin && @user.site_admin.nil?
        @user.site_admin = SiteAdmin.new
      elsif !(@is_admin || @user.site_admin.nil?)
        @user.site_admin = nil
      end

      result = @user.save
      if result
        success result
      else
        failure 'Could not save user'
      end
    end
  end
end
