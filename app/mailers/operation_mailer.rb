class OperationMailer < ApplicationMailer
  default from: 'joao@banfox.com.br'

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

  def deposited_without_limit(operation, user, seller)
    @operation = operation
    @installments = operation.installments
    user = user
    @seller = seller

    mail(
      to: set_recipients(user.email, @seller.email_partner),
      subject: 'Seu dinheiro já está a caminho!'
      )
  end

  def signed(operation, email)
    seller = operation&.seller
    @operation = operation
    @name = ""

    if seller&.email_partner == email
      @name = seller&.full_name
    else
      seller&.joint_debtors&.each do |joint|
        @name = joint&.name if joint&.email == email
      end
    end

    mail(
      to: email,
      subject: 'Assinatura efetuada!'
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

