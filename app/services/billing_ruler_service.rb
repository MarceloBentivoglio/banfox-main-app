class BillingRulerService

  def initialize(sellers)
    @sellers = sellers
  end

  def daily_billing_mail_checker
    @sellers.each do |seller|
      due_date_mail_sender(seller)
      just_overdued_mail_sender(seller)
      overdue_mail_sender(seller)
      overdue_pre_serasa_mail_sender(seller)
      sending_to_serasa_mail_sender(seller)
      overdue_after_serasa_mail_sender(seller)
      protest_mail_sender(seller)
    end
  end

  def monthly_organization_mail_sender
    no_installments = true
    @sellers.each do |seller|
      installments = seller.monthly_organization_eligible_installments
      unless installments.empty?
        no_installments = false
        send_mails("monthly_organization", seller, installments) 
      end
    end

    if no_installments
      SlackMessage.new("CPVKLBR3J", "<!channel> Nenhum e-mail de Organização Mensal foi enviado").send_now
    else
      SlackMessage.new("CPVKLBR3J", "<!channel> Enviados e-mails de Organização Mensal").send_now
    end
  end

  def weekly_organization_mail_sender
    no_installments = true
    @sellers.each do |seller|
      installments = seller.weekly_organization_eligible_installments
      unless installments.empty?
        no_installments = false
        send_mails("weekly_organization", seller, installments) 
      end
    end

    if no_installments
      SlackMessage.new("CPVKLBR3J", "<!channel> Nenhum e-mail de Organização Semanal foi enviado").send_now
    else
      SlackMessage.new("CPVKLBR3J", "<!channel> Enviados e-mails de Organização Semanal").send_now
    end
  end

  def due_date_mail_sender(seller)
    installments = seller.due_date_eligible_installments
    slack_text = "vencem hoje"
    process_billing_ruler("due_date", seller, installments, slack_text) unless installments.empty?
  end

  def just_overdued_mail_sender(seller)
    installments = seller.just_overdued_eligible_installments
    slack_text = "acabaram de vencer"
    process_billing_ruler("just_overdued", seller, installments, slack_text) unless installments.empty?
  end

  def overdue_mail_sender(seller)
    installments = seller.overdue_eligible_installments
    slack_text = "estão vencidos(4 ~ 9 dias após data de vencimento)"
    process_billing_ruler("overdue", seller, installments, slack_text) unless installments.empty?
  end

  def overdue_pre_serasa_mail_sender(seller)
    installments = seller.overdue_pre_serasa_eligible_installments
    slack_text = "estão vencidos(10 ~ 19 dias após data de vencimento)"
    process_billing_ruler("overdue_pre_serasa", seller, installments, slack_text) unless installments.empty?
  end

  def sending_to_serasa_mail_sender(seller)
    installments = seller.sending_to_serasa_eligible_installments
    slack_text = "serão negativados"
    process_billing_ruler("sending_to_serasa", seller, installments, slack_text) unless installments.empty?
  end
     
  def overdue_after_serasa_mail_sender(seller)
    installments = seller.overdue_after_serasa_eligible_installments
    slack_text = "estão vencidos(21 ~ 29 dias após data de vencimento)"
    process_billing_ruler("overdue_after_serasa", seller, installments, slack_text) unless installments.empty?
  end

  def protest_mail_sender(seller)
    installments = seller.protest_eligible_installments
    slack_text = "serão protestados"
    process_billing_ruler("protest", seller, installments, slack_text) unless installments.empty?
  end

  def process_billing_ruler(method, seller, installments, slack_text)
    billing_ruler = billing_ruler_mails(method, installments, seller)
    send_mails(method, seller, installments, billing_ruler.code)
    billing_ruler_slack(installments, seller, slack_text)
  end

  def send_mails(method, seller, installments, billing_code = nil)
    if billing_code
      SellerMailer.send(method, seller.users.first, seller, installments, billing_code).deliver_now
    else
      SellerMailer.send(method, seller.users.first, seller, installments).deliver_now
    end
  end

  def billing_ruler_slack(installments, seller, slack_text)
    installments_text = ""
    installments.each do |i|
      installments_text += "#{i.invoice.number}/#{i.number} \n "
    end
    SlackMessage.new("CPM2L0ESD", 
                     "<!channel> Enviado ao cliente #{seller.company_name&.titleize} o e-mail de aviso que os títulos abaixo #{slack_text}: \n #{installments_text}").send_now
  end

  def billing_ruler_mails(method, installments, seller)
    billing_ruler = BillingRuler.new
    billing_ruler.seller = seller
    billing_ruler.installments = installments
    billing_ruler.code = SecureRandom.uuid
    billing_ruler.send(method + "!")
    billing_ruler.send_to_seller!
    billing_ruler
  end
end
