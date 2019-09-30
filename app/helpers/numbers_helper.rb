module NumbersHelper

  def percentage(number)
    number = number*100
    return number_to_percentage(number, precision: 1, delimiter: '.', separator: ',')
  end

  def money_with_cents(money)
    "#{money_without_cents money}#{money_only_cents money}"
  end


end
