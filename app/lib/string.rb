# frozen_string_literal: true

# Extension methods for the String class
class String
  TRUTHY = %w[true yes t on].freeze

  def to_b
    TRUTHY.include? self
  end
end
