class InstallmentMailerPreview < ActionMailer::Preview
  def paid
    InstallmentMailer.paid(Installment.first, User.first, Seller.first).deliver_now
  end

  def paid_overdue
    InstallmentMailer.paid_overdue(Installment.first, User.first, Seller.first).deliver_now
  end

  def paid_without_protection
    InstallmentMailer.paid_without_protection(Installment.last, User.first, Seller.first).deliver_now
  end

  def paid_overdue_without_protection
    InstallmentMailer.paid_overdue_without_protection(Installment.last, User.first, Seller.first).deliver_now
  end

end
