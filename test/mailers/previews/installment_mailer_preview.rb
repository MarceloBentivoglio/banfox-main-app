class InstallmentMailerPreview < ActionMailer::Preview
  def paid
    InstallmentMailer.paid(Installment.first, User.first, Seller.first).deliver_now
  end

  def paid_overdue
    InstallmentMailer.paid_overdue(Installment.find(6), User.first, Seller.first).deliver_now
  end

  def paid_ahead
    InstallmentMailer.paid_ahead(Installment.find(18), User.first, Seller.first).deliver_now
  end

end
