# frozen_string_literal: true

class ApplicationService
  def self.call(*args, &block)
    new(*args, &block).call
  end

  def success(payload)
    OpenStruct.new { success?: true, payload: payload }
  end

  def failure(message)
    OpenStruct.new { success?: false, error: message }
  end
end
