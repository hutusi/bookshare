class String
  def try_to_datetime
    to_datetime
  rescue ArgumentError
    nil
  end
end
