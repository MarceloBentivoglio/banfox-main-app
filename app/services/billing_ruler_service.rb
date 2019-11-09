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
      installments = []
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
      installments = []
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
    installments = []
    installments = seller.due_date_eligible_installments
    unless installments.empty?
      slack_text = installments_slack_text(installments)
      billing_ruler = billing_ruler_mails("due_date", installments, seller)
      SlackMessage.new("CPM2L0ESD", 
                       "<!channel> Enviado ao cliente #{@seller.company_name&.titleize} o e-mail de aviso que os títulos abaixo vencem hoje: \n #{slack_text}").send_now
      send_mails("due_date", seller, installments, billing_ruler.code)
    end
  end

  def send_mails(method, seller, installments, billing_code = nil)
    if billing_code
      SellerMailer.send(method, seller.users.first, seller, installments, billing_code).deliver_now
    else
      SellerMailer.send(method, seller.users.first, seller, installments).deliver_now
    end
  end

  def installments_slack_text(installments)
    installments_text = ""
    installments.each do |i|
      installments_text += "#{i.invoice.number}/#{i.number} \n "
    end
    installments_text
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

=begin
  def send_mails
    today = Date.today
    installments = []
    week_installments = []
    due_date_installments = []
    just_overdued_installments = []
    overdue_installments = []
    overdue_pre_serasa_installments = []
    sending_to_serasa_installments = []
    overdue_after_serasa_installments = []
    protest_installments = []
    no_installments = true
    @sellers.each do |seller|
        SlackMessage.new("CPVKLBR3J", "<!channel> Enviados e-mails de Organização Semanal").send_now
        seller.invoices.each do |invoice|
          invoice.installments.each do |installment|
            week_installments << installment if installment.opened? && installment.due_date.between?(Date.today.beginning_of_week, Date.today.end_of_week)
          end
        end
        SellerMailer.weekly_organization(seller.users.first, seller, week_installments).deliver_now

      seller.invoices.each do |invoice|
        invoice.installments.each do |installment|
          installments << installment if installment.opened? && installment.due_date <= today
        end
      end

      installments.each do |installment|
        case today - installment.due_date
        when 0..2
          due_date_installments << installment
          no_installments = false
        when 3
          just_overdued_installments << installment
          no_installments = false
        when 4..8
          overdue_installments << installment
          no_installments = false
        when 9..18
          overdue_pre_serasa_installments << installment
          no_installments = false
        when 19
          sending_to_serasa_installments << installment
          no_installments = false
        when 22..28
          overdue_after_serasa_installments << installment
          no_installments = false
        when 29
          protest_installments << installment
          no_installments = false
        end
      end

      billing_ruler_mails("due_date", due_date_installments, seller) unless due_date_installments.empty?
      billing_ruler_mails("just_overdued", just_overdued_installments, seller) unless just_overdued_installments.empty?
      billing_ruler_mails("overdue", overdue_installments, seller) unless overdue_installments.empty?
      billing_ruler_mails("overdue_pre_serasa", overdue_pre_serasa_installments, seller) unless overdue_pre_serasa_installments.empty?
      billing_ruler_mails("sending_to_serasa", sending_to_serasa_installments, seller) unless sending_to_serasa_installments.empty?
      billing_ruler_mails("overdue_after_serasa", overdue_after_serasa_installments, seller) unless overdue_after_serasa_installments.empty?
      billing_ruler_mails("protest", protest_installments, seller) unless protest_installments.empty?
    end

    if no_installments
      SlackMessage.new("CPVKLBR3J", "<!channel> Nenhum e-mail foi enviado hoje.").send_now
    end
  end
=end

end
