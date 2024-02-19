# frozen_string_literal: true

# Controller for managing users in the application
class UserController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to user_profile_path, notice: I18n.t('profile.update.success')
    else
      render :edit
    end
  end

  def destroy
    current_user.destroy
    redirect_to root_path, notice: I18n.t('account.destroy.success')
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :type, :name)
  end
end
