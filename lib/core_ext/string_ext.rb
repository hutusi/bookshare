# frozen_string_literal: true

class String
  def try_to_datetime
    to_datetime
  rescue ArgumentError
    begin
      data = self.match(/(\d+)\-(\d+)/)
      if data
        DateTime.new(data[1].to_i, data[2].to_i)
      else
        DateTime.new(1900, 1)
      end
    rescue ArgumentError
      DateTime.new(1900, 1)
    end
  end
end
