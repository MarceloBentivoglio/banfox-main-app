class SellerMailerPreview < ActionMailer::Preview
  def welcome
    user = User.first
    seller = Seller.first
    SellerMailer.welcome(user, seller)
  end
end
