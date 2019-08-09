class InstallmentMailerPreview < ActionMailer::Preview
  def paid
    InstallmentMailer.paid(Installment.first, User.first, Seller.first).deliver_now
  end

  def paid_overdue
    InstallmentMailer.paid_overdue(Installment.find(6), User.first, Seller.first).deliver_now
  end

  def paid_without_protection
    InstallmentMailer.paid_without_protection(Installment.find(75), User.find(11), Seller.find(10)).deliver_now
  end

  def paid_overdue_without_protection
    InstallmentMailer.paid_overdue_without_protection(Installment.find(76), User.find(11), Seller.find(10)).deliver_now
  end

end
