# frozen_string_literal: true

# Helper functions for the admin controllers
module AdminHelper
  def check_access_rights
    authorize! :manage, :admin_dashboard
  end
end
