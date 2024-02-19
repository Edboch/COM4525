class UserController < ApplicationController
  before_action :authenticate_user!
  
  def show
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to user_profile_path, notice: 'Profile was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    current_user.destroy
    redirect_to root_path, notice: 'Your account has been successfully deleted.'
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :type, :name)
  end
end
