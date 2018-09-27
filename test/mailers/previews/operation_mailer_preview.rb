class OperationMailerPreview < ActionMailer::Preview
  def to_analysis
    operation = Operation.last
    user = User.first
    seller = operation.installments.first.invoice.seller
    OperationMailer.to_analysis(operation, user, seller)
  end

  def rejected
    operation = Operation.last
    user = User.first
    seller = operation.installments.first.invoice.seller
    OperationMailer.rejected(operation, user, seller)
  end

  def approved
    operation = Operation.last
    user = User.first
    seller = operation.installments.first.invoice.seller
    OperationMailer.approved(operation, user, seller)
  end

  def partially_approved
    operation = Operation.last
    user = User.first
    seller = operation.installments.first.invoice.seller
    OperationMailer.partially_approved(operation, user, seller)
  end
end
