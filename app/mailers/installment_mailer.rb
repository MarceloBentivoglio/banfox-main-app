class InstallmentMailer < ApplicationMailer
  default from: 'joao@banfox.com.br'

  def paid(installment, user, seller)
    @seller = seller
    mail(
      to: set_recipients(user.email, @seller.email_partner),
      subject: 'Sua parcela foi liquidada!'
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

