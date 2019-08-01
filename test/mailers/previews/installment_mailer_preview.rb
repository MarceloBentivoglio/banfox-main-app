class InstallmentMailerPreview < ActionMailer::Preview
  def paid
    InstallmentMailer.paid(self, User.first, Seller.first).deliver_now
  end
end
