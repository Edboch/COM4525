# frozen_string_literal: true

# Helper to provide functions for creating responses for classes classes
module ServiceHelper
  def success(payload = nil)
    { success?: true, payload: payload }
  end

  def failure(message)
    { success?: false, error: message }
  end
end
