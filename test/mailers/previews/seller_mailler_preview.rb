class SellerMailerPreview < ActionMailer::Preview
  def rejected
    SellerMailer.rejected(User.first, User.first.seller).deliver_now
  end

  def welcome
    SellerMailer.welcome(User.first, User.first.seller).deliver_now
  end

  def monthly_organization
    SellerMailer.monthly_organization(User.first, User.first.seller).deliver_now
  end

  def weekly_organization
    SellerMailer.weekly_organization(User.first, User.first.seller).deliver_now
  end

  def due_date
    installments_text = "100/1 \n 100/2 \n 234/1 \n 444/4 \n"
    billing_ruler = BillingRuler.first
    seller = billing_ruler.seller
    installments = billing_ruler.installments
    code = billing_ruler.code
    SellerMailer.due_date(User.first, seller, installments, installments_text, code).deliver_now
  end

  def just_overdued
    installments_text = "100/1 \n 100/2 \n 234/1 \n 444/4 \n"
    billing_ruler = BillingRuler.first
    seller = billing_ruler.seller
    installments = billing_ruler.installments
    code = billing_ruler.code
    SellerMailer.just_overdued(User.first, seller, installments, installments_text, code).deliver_now
  end

  def overdue
    installments_text = "100/1 \n 100/2 \n 234/1 \n 444/4 \n"
    billing_ruler = BillingRuler.first
    seller = billing_ruler.seller
    installments = billing_ruler.installments
    code = billing_ruler.code
    SellerMailer.overdue(User.first, seller, installments, installments_text, code).deliver_now
  end

  def overdue_pre_serasa
    installments_text = "100/1 \n 100/2 \n 234/1 \n 444/4 \n"
    billing_ruler = BillingRuler.first
    seller = billing_ruler.seller
    installments = billing_ruler.installments
    code = billing_ruler.code
    SellerMailer.overdue_pre_serasa(User.first, seller, installments, installments_text, code).deliver_now
  end

  def sending_to_serasa
    installments_text = "100/1 \n 100/2 \n 234/1 \n 444/4 \n"
    billing_ruler = BillingRuler.first
    seller = billing_ruler.seller
    installments = billing_ruler.installments
    code = billing_ruler.code
    SellerMailer.sending_to_serasa(User.first, seller, installments, installments_text, code).deliver_now
  end

  def overdue_after_serasa
    installments_text = "100/1 \n 100/2 \n 234/1 \n 444/4 \n"
    billing_ruler = BillingRuler.first
    seller = billing_ruler.seller
    installments = billing_ruler.installments
    code = billing_ruler.code
    SellerMailer.overdue_after_serasa(User.first, seller, installments, installments_text, code).deliver_now
  end

  def protest
    installments_text = "100/1 \n 100/2 \n 234/1 \n 444/4 \n"
    billing_ruler = BillingRuler.first
    seller = billing_ruler.seller
    installments = billing_ruler.installments
    code = billing_ruler.code
    SellerMailer.protest(User.first, seller, installments, installments_text, code).deliver_now
  end
end
