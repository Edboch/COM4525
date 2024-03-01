# frozen_string_literal: true

module Users
  # Controller for handling registrations with devise in the application
  class RegistrationsController < Devise::RegistrationsController
    include AuthenticationHelper

    before_action :configure_sign_up_params, only: [:create]
    before_action :configure_account_update_params, only: [:update]
    skip_before_action :check_user_authenticated

    def create
      super(resource)
    end

    def update
      super(resource)
    end

    protected

    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up,
                                        keys: [:email, :password, :password_confirmation, :name, { role_ids: [] }])
    end

    def configure_account_update_params
      devise_parameter_sanitizer.permit(:account_update,
                                        keys: %i[email password password_confirmation current_password type])
    end

    # The path used after sign up.
    # def after_sign_up_path_for(resource)
    #   super(resource)
    # end

    # The path used after sign up for inactive accounts.
    # def after_inactive_sign_up_path_for(resource)
    #   super(resource)
    # end
  end
end
