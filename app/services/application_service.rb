# frozen_string_literal: true

# Base class for all service classes
# Provides some functionality to make using them easier
class ApplicationService
  def self.call(...)
    new(...).call
  end

  def success(payload = nil)
    Hash.new success?: true, payload: payload
  end

  def failure(message)
    Hash.new success?: false, error: message
  end
end
