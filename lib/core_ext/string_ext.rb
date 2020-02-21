# frozen_string_literal: true

class String
  def try_to_datetime
    str = strip
    case str[4]
    when '-'
      data = str.match(/(\d+)\-(\d+)\-*(\d*)/)
      raise ArgumentError unless data

      DateTime.new(data[1].to_i, data[2].to_i, data[3].to_i == 0 ? 1 : data[3].to_i)
    when '.'
      data = str.match(/(\d+)\.(\d+)\.*(\d*)/)
      raise ArgumentError unless data

      DateTime.new(data[1].to_i, data[2].to_i, data[3].to_i == 0 ? 1 : data[3].to_i)
    when '年'
      data = str.match(/(\d+)年(\d*)月*(\d*)/)
      raise ArgumentError unless data

      DateTime.new(data[1].to_i, data[2].to_i == 0 ? 1 : data[2].to_i, data[3].to_i == 0 ? 1 : data[3].to_i)
    when nil # such as 2000
      DateTime.new(str.to_i, 1, 1)
    else
      to_datetime
    end
  rescue ArgumentError
    nil
  end
end
