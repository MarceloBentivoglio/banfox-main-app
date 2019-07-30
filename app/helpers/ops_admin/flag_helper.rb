module OpsAdmin::FlagHelper
  def span_flag(flag_code)
    case flag_code
    when -1
      'gray_flag'
    when 0
      'green_flag'
    when 1
      'yellow_flag'
    when 2
      'red_flag'
    end
  end
end
