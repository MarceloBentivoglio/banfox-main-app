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
  def monthly_organization(user, seller)
    user = user
    @seller = seller
    @installments = []
    seller.invoices.each do |invoice|
      invoice.installments.each do |installment|
        @installments << installment if installment.opened? && installment.due_date.month == Date.today.month
      end
    end
    mail(
      to: set_recipients(user.email, @seller.email_partner),
      subject: 'Organização Mensal Banfox'
      )
  end

  def weekly_organization(user, seller)
    user = user
    @seller = seller
    @installments = []
    seller.invoices.each do |invoice|
      invoice.installments.each do |installment|
        @installments << installment if installment.opened? && installment.due_date.between?(Date.today.beginning_of_week, Date.today.end_of_week)
      end
    end
    mail(
      to: set_recipients(user.email, @seller.email_partner),
      subject: 'Organização Semanal Banfox'
      )
  end

  def due_date(user, seller, installments_text)
    user = user
    @seller = seller
    @installments = []
    seller.invoices.each do |invoice|
      invoice.installments.each do |installment|
        @installments << installment if installment.opened? && installment.due_date.between?(Date.today - 3, Date.today)
      end
    end
    SlackMessage.new("CPM2L0ESD", 
                     "<!channel> Enviado ao cliente #{@seller.company_name&.titleize} 
                     o e-mail de aviso do vencimento dos titulos: \n #{installments_text}").send_now
    mail(
      to: set_recipients(user.email, @seller.email_partner),
      subject: 'Títulos Banfox vencendo hoje.'
      )
  end

  def just_overdued(user, seller)
    user = user
    @seller = seller
    @installments = []
    @balances = Money.new(0)
    seller.invoices.each do |invoice|
      invoice.installments.each do |installment|
        if installment.opened? && installment.due_date + 4 == Date.today
          @installments << installment
          @balances += installment.delta_fee
        end
      end
    end
    mail(
      to: set_recipients(user.email, @seller.email_partner),
      subject: 'Títulos Banfox acabaram de vencer.'
      )
  end

  def overdue(user, seller)
    user = user
    @seller = seller
    @installments = []
    @balances = Money.new(0)
    seller.invoices.each do |invoice|
      invoice.installments.each do |installment|
        if installment.opened? && installment.overdue? && installment.due_date.between?(Date.today - 13, Date.today - 5)
          @installments << installment
          @balances += installment.delta_fee
        end
      end
    end
    mail(
      to: set_recipients(user.email, @seller.email_partner),
      subject: 'Títulos Banfox atrasados.'
      )
  end

  def overdue_pre_serasa(user, seller)
    user = user
    @seller = seller
    @installments = []
    @balances = Money.new(0)
    seller.invoices.each do |invoice|
      invoice.installments.each do |installment|
        if installment.opened? && installment.overdue? && installment.due_date.between?(Date.today - 23, Date.today - 14)
          @installments << installment       
          @balances += installment.delta_fee
        end
      end
    end
    mail(
      to: set_recipients(user.email, @seller.email_partner),
      subject: 'Títulos Banfox atrasados. Cuidado com a negativação.'
      )
  end

  def sending_to_serasa(user, seller)
    user = user
    @seller = seller
    @installments = []
    @total_value = Money.new(0)
    @balances = Money.new(0)
    seller.invoices.each do |invoice|
      invoice.installments.each do |installment|
        #TODO flag para negativação?
        if installment.opened? && installment.overdue? && installment.due_date == Date.today - 24
          @installments << installment
          @total_value += installment.value
          @balances += installment.delta_fee
        end
      end
    end
    mail(
      to: set_recipients(user.email, @seller.email_partner),
      subject: 'Títulos Banfox serão enviados para negativação.'
      )
  end

  def overdue_after_serasa(user, seller)
    user = user
    @seller = seller
    @installments = []
    @total_value = Money.new(0)
    @balances = Money.new(0)
    seller.invoices.each do |invoice|
      invoice.installments.each do |installment|
        #TODO flag para negativação?
        if installment.opened? && installment.overdue? && installment.due_date.between?(Date.today - 33, Date.today - 25)
          @installments << installment
          @total_value += installment.value
          @balances += installment.delta_fee
        end
      end
    end
    mail(
      to: set_recipients(user.email, @seller.email_partner),
      subject: 'Títulos Banfox negativados.'
      )
  end

  def protest(user, seller)
    user = user
    @seller = seller
    @installments = []
    @total_value = Money.new(0)
    @balances = Money.new(0)
    seller.invoices.each do |invoice|
      invoice.installments.each do |installment|
        #TODO flag para negativação?
        if installment.opened? && installment.overdue? && installment.due_date == Date.today - 34
          @installments << installment
          @total_value += installment.value
          @balances += installment.delta_fee
        end
      end
    end
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
