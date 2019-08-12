module OpsAdmin::FlagHelper
  def span_flag(flag_code)
    case flag_code
    when -1
      'gray-flag'
    when 0
      'green-flag'
    when 1
      'yellow-flag'
    when 2
      'red-flag'
    end
  end
end
