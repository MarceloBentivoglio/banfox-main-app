class SellerMailer < ApplicationMailer
  default from: 'marcelo.bentivoglio@mvpinvest.com.br'

  def welcome(user, seller)
    user = user
    @seller = seller

    mail(
      to: [user.email, @seller.email_partner],
      subject: 'Bem vindo à MVP Invest'
      )
  end

  def rejected(user, seller)
    user = user
    @seller = seller

    mail(
      to: [user.email, @seller.email_partner],
      subject: 'Ainda não conseguimos te ajudar'
      )
  end
end
