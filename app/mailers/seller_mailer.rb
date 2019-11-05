class SellerMailer < ApplicationMailer
  add_template_helper(InfoMasksHelper)
  default from: 'marcelo@banfox.com.br'

  def welcome(user, seller)
    user = user
    @seller = seller

    mail(
      to: set_recipients(user.email, @seller.email_partner),
      subject: 'Bem vindo à Banfox'
      )
  end

  def rejected(user, seller)
    user = user
    @seller = seller

    mail(
      to: set_recipients(user.email, @seller.email_partner),
      subject: 'Ainda não conseguimos te ajudar'
      )
  end

  #billing ruler
  def monthly_organization(user, seller, installments)
    user = user
    @seller = seller
    @installments = installments
    mail(
      to: set_recipients(user.email, @seller.email_partner),
      subject: 'Organização Mensal Banfox'
      )
  end

  def weekly_organization(user, seller, installments)
    user = user
    @seller = seller
    @installments = installments
    mail(
      to: set_recipients(user.email, @seller.email_partner),
      subject: 'Organização Semanal Banfox'
      )
  end

  def due_date(user, seller, installments, installments_text, billing_ruler_code)
    user = user
    @seller = seller
    @installments = installments
    @response_url = "#{ENV.fetch('APPHOST')}/api/v1/billing_ruler_responses/#{billing_ruler_code}"
    SlackMessage.new("CPM2L0ESD", 
                     "<!channel> Enviado ao cliente #{@seller.company_name&.titleize} 
                     o e-mail de aviso que os títulos abaixo vencem hoje: \n #{installments_text}").send_now
    mail(
      to: set_recipients(user.email, @seller.email_partner),
      subject: 'Títulos Banfox vencendo hoje.'
      )
  end

  def just_overdued(user, seller, installments, installments_text, billing_ruler_code)
    user = user
    @seller = seller
    @installments = installments
    @balances = Money.new(0)
    @response_url = "#{ENV.fetch('APPHOST')}/api/v1/billing_ruler_responses/#{billing_ruler_code}"
    @installments.each do | installment|
      @balances += installment.delta_fee
    end
    SlackMessage.new("CPM2L0ESD", 
                     "<!channel> Enviado ao cliente #{@seller.company_name&.titleize} 
                     o e-mail de aviso que os títulos abaixo acabaram de vencer: \n #{installments_text}").send_now
    mail(
      to: set_recipients(user.email, @seller.email_partner),
      subject: 'Títulos Banfox acabaram de vencer.'
      )
  end

  def overdue(user, seller, installments, installments_text, billing_ruler_code)
    user = user
    @seller = seller
    @installments = installments
    @balances = Money.new(0)
    @response_url = "#{ENV.fetch('APPHOST')}/api/v1/billing_ruler_responses/#{billing_ruler_code}"
    @installments.each do |installment|
      @balances += installment.delta_fee
    end
    SlackMessage.new("CPM2L0ESD", 
                     "<!channel> Enviado ao cliente #{@seller.company_name&.titleize} 
                     o e-mail de aviso que os títulos abaixo estão vencidos(2º ~ 10º dia de atraso): \n #{installments_text}").send_now
    mail(
      to: set_recipients(user.email, @seller.email_partner),
      subject: 'Títulos Banfox atrasados.'
      )
  end

  def overdue_pre_serasa(user, seller, installments, installments_text, billing_ruler_code)
    user = user
    @seller = seller
    @installments = installments
    @balances = Money.new(0)
    @response_url = "#{ENV.fetch('APPHOST')}/api/v1/billing_ruler_responses/#{billing_ruler_code}"
    @installments.each do |installment|
      @balances += installment.delta_fee
    end
    SlackMessage.new("CPM2L0ESD", 
                     "<!channel> Enviado ao cliente #{@seller.company_name&.titleize} 
                     o e-mail de aviso que os títulos abaixo estão vencidos(11º ~ 20º dia de atraso): \n #{installments_text}").send_now
    mail(
      to: set_recipients(user.email, @seller.email_partner),
      subject: 'Títulos Banfox atrasados. Cuidado com a negativação.'
      )
  end

  def sending_to_serasa(user, seller, installments, installments_text, billing_ruler_code)
    user = user
    @seller = seller
    @installments = installments
    @total_value = Money.new(0)
    @balances = Money.new(0)
    @response_url = "#{ENV.fetch('APPHOST')}/api/v1/billing_ruler_responses/#{billing_ruler_code}"
    @installments.each do |installment|
      #TODO flag para negativação?
      @total_value += installment.value
      @balances += installment.delta_fee
    end
    SlackMessage.new("CPM2L0ESD", 
                     "<!channel> Enviado ao cliente #{@seller.company_name&.titleize} 
                     o e-mail de aviso que os títulos abaixo serão negativados: \n #{installments_text}").send_now
    mail(
      to: set_recipients(user.email, @seller.email_partner),
      subject: 'Títulos Banfox serão enviados para negativação.'
      )
  end

  def overdue_after_serasa(user, seller, installments, installments_text, billing_ruler_code)
    user = user
    @seller = seller
    @installments = installments
    @total_value = Money.new(0)
    @balances = Money.new(0)
    @response_url = "#{ENV.fetch('APPHOST')}/api/v1/billing_ruler_responses/#{billing_ruler_code}"
    @installments.each do |installment|
      @total_value += installment.value
      @balances += installment.delta_fee
    end
    SlackMessage.new("CPM2L0ESD", 
                     "<!channel> Enviado ao cliente #{@seller.company_name&.titleize} 
                     o e-mail de aviso que os títulos abaixo estão vencidos(22º ~ 30º dia de atraso): \n #{installments_text}").send_now
    mail(
      to: set_recipients(user.email, @seller.email_partner),
      subject: 'Títulos Banfox negativados.'
      )
  end

  def protest(user, seller, installments, installments_text, billing_ruler_code)
    user = user
    @seller = seller
    @installments = installments
    @total_value = Money.new(0)
    @balances = Money.new(0)
    @response_url = "#{ENV.fetch('APPHOST')}/api/v1/billing_ruler_responses/#{billing_ruler_code}"
    @installments.each do |installment|
      @total_value += installment.value
      @balances += installment.delta_fee
    end
    SlackMessage.new("CPM2L0ESD", 
                     "<!channel> Enviado ao cliente #{@seller.company_name&.titleize} 
                     o e-mail de aviso que os títulos abaixo serão protestados: \n #{installments_text}").send_now
    mail(
      to: set_recipients(user.email, @seller.email_partner),
      subject: 'Títulos Banfox serão protestados.'
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
