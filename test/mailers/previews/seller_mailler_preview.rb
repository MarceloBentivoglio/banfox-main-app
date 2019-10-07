class SellerMailerPreview < ActionMailer::Preview
  def rejected
    SellerMailer.rejected(User.first, User.first.seller).deliver_now
  end

  def welcome
    SellerMailer.welcome(User.first, User.first.seller).deliver_now
  end
end
