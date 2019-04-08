class OperationMailer < ApplicationMailer
  default from: 'marcelo@banfox.com.br'

  def to_analysis(operation, user, seller)
    @operation = operation
    @installments = operation.installments
    user = user
    @seller = seller

    mail(
      to: set_recipients(user.email, @seller.email_partner),
      subject: 'Sua operação já está em análise'
      )
  end

  def rejected(operation, user, seller)
    @operation = operation
    @installments = operation.installments
    user = user
    @seller = seller

    mail(
      to: set_recipients(user.email, @seller.email_partner),
      subject: 'Infelizmente sua operação foi rejeitada'
      )
  end

  def approved(operation, user, seller)
    @operation = operation
    @installments = operation.installments
    user = user
    @seller = seller

    mail(
      to: set_recipients(user.email, @seller.email_partner),
      subject: 'Sua operação foi aprovada!'
      )
  end

  def partially_approved(operation, user, seller)
    @operation = operation
    @installments = operation.installments
    user = user
    @seller = seller

    mail(
      to: set_recipients(user.email, @seller.email_partner),
      subject: 'Sua operação foi aprovada parcialmente!'
      )
  end

  def deposited(operation, user, seller)
    @operation = operation
    @installments = operation.installments
    user = user
    @seller = seller

    mail(
      to: set_recipients(user.email, @seller.email_partner),
      subject: 'Seu dinheiro já está a caminho!'
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

