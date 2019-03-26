module NumbersHelper

  def percentage(number)
    number = number*100
    # return "#{(number*100).round(1)}%"
    # return "#{number_with_precision(number*100, precision: 2)}%"
    number_to_percentage(number, precision: 1, delimiter: '.', separator: ',')
  end

end
