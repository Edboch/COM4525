# frozen_string_literal: true

# Provides application authorisation helper methods
module AuthenticationHelper
  def check_user_authenticated
    redirect_to root_path unless user_signed_in?
  end

  def after_sign_in_path_for(_resource)
    dashboard_path
  end

  def after_sign_out_path_for(_resource_or_scope)
    root_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up,
                                      keys: [:email, :password, :password_confirmation, :name, { role_ids: [] }])
    devise_parameter_sanitizer.permit(:account_update,
                                      keys: %i[email password password_confirmation current_password type name])
  end
end
