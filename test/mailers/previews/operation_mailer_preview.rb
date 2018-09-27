class OperationMailerPreview < ActionMailer::Preview
  def to_analysis
    operation = Operation.last
    user = User.first
    seller = Seller.first
    OperationMailer.to_analysis(operation, user, seller)
  end
end
