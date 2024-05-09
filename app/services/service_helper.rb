module ServiceHelper
  def success(payload = nil)
    return { success?: true, payload: payload }
  end

  def failure(message)
    return { success?: false, error: message }
  end
end
