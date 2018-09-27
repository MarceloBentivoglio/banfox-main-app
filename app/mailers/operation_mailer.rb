class OperationMailer < ApplicationMailer
  default from: 'marcelo.bentivoglio@mvpinvest.com.br'

  def to_analysis(operation, user, seller)
    @operation = operation
    @installments = operation.installments
    user = user
    @seller = seller

    mail(
      to: [user.email, @seller.email_partner],
      subject: 'Sua operação já está em análise'
      )
  end
end

