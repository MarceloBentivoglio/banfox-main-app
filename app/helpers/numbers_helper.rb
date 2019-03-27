module NumbersHelper

  def percentage(number)
    number = number*100
    return number_to_percentage(number, precision: 1, delimiter: '.', separator: ',')
  end

end
