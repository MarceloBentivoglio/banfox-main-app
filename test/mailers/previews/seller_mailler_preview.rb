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
    SellerMailer.due_date(User.first, User.first.seller, installments_text).deliver_now
  end

  def just_overdued
    SellerMailer.just_overdued(User.first, User.first.seller).deliver_now
  end

  def overdue
    SellerMailer.overdue(User.first, User.first.seller).deliver_now
  end

  def overdue_pre_serasa
    SellerMailer.overdue_pre_serasa(User.first, User.first.seller).deliver_now
  end

  def sending_to_serasa
    SellerMailer.sending_to_serasa(User.first, User.first.seller).deliver_now
  end

  def overdue_after_serasa
    SellerMailer.overdue_after_serasa(User.first, User.first.seller).deliver_now
  end

  def protest
    SellerMailer.protest(User.first, User.first.seller).deliver_now
  end
end
