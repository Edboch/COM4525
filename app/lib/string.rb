class String
  TRUTHY = [ 'true', 'yes', 't' ]

  def to_b
    TRUTHY.include? self
  end
end
