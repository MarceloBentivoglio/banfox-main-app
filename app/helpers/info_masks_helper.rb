module InfoMasksHelper

  def invoice_complete_number_mask(number_str)
    return number_str.rjust(9,'0').scan(/.{3}/).join(".")
  end

  def invoice_partial_number_mask(number_str)
    return number_str.last(3).rjust(3,'0').scan(/.{3}/).join()
  end

  def installment_number_mask(number_str)
    return number_str.rjust(2,'0')
  end

  def invoice_installment_complete_number_mask(invoice_number,installment_number)
    return "#{invoice_complete_number_mask(invoice_number)}/#{installment_number_mask(installment_number)}"
  end

  def invoice_installment_partial_number_mask(invoice_number,installment_number)
    return "#{invoice_partial_number_mask(invoice_number)}/#{installment_number_mask(installment_number)}"
  end

end
