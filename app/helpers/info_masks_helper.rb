module InfoMasksHelper

  def invoice_number_mask(number_str)
    return number_str.rjust(9,'0').scan(/.{3}/).join(".")
  end

  def installment_number_mask(number_str)
    return number_str.rjust(2,'0')
  end

  def invoice_installment_number_mask(invoice_number,installment_number)
    return "#{invoice_number_mask(invoice_number)}/#{installment_number_mask(installment_number)}"
  end


end
