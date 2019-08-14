class InstallmentMailer < ApplicationMailer
  default from: 'joao@banfox.com.br'

  def paid(installment, user, seller)
    @seller = seller
    @installment = installment
    mail(
      to: set_recipients(user.email, @seller.email_partner),
      subject: "Recebemos o pagamento do título  #{@installment&.invoice&.number}/#{@installment.number} da operação #{@installment&.operation&.id}"
      )
  end

  def paid_overdue(installment, user, seller)
    @seller = seller
    @installment = installment
    mail(
      to: set_recipients(user.email, @seller.email_partner),
      subject: "Recebemos o pagamento do título  #{@installment&.invoice&.number}/#{@installment.number} da operação #{@installment&.operation&.id}"
      )
  end


  def paid_without_protection(installment, user, seller)
    @seller = seller
    @installment = installment
    mail(
      to: set_recipients(user.email, @seller.email_partner),
      subject: "Recebemos o pagamento do título  #{@installment&.invoice&.number}/#{@installment.number} da operação #{@installment&.operation&.id}"
      )
  end

  def paid_overdue_without_protection(installment, user, seller)
    @seller = seller
    @installment = installment
    mail(
      to: set_recipients(user.email, @seller.email_partner),
      subject: "Recebemos o pagamento do título  #{@installment&.invoice&.number}/#{@installment.number} da operação #{@installment&.operation&.id}"
      )
  end

  private

  def set_recipients(contact_email, partner_email)
    if contact_email == partner_email
      return contact_email
    else
      return [contact_email, partner_email]
    end
  end
end
