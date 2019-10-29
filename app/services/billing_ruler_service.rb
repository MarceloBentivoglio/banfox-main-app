class BillingRulerService
  add_template_helper(InfoMasksHelper)

  def initialize(seller, installment_ids, method)
    @seller = seller
    @installment_ids = installment_ids
    @method = method
  end

  def monthly_organization
    SellerMailer.monthly_organization(@seller.users.first, @seller).deliver_now
  end

  def weekly_organization
    SellerMailer.weekly_organization(@seller.users.first, @seller).deliver_now
  end

  def billing_ruler_mails
    billing_ruler = BillingRuler.new
    billing_ruler.seller = seller
    installments << Installment.find(@installment_ids)
    installments.each do |i|
      billing_ruler.installments << i
    end
    billing_ruler.code = SecureRandom.uuid
    billing_ruler.send_to_seller!
    installments_text = ""
    installments.each do |i|
      installments_text += "#{invoice_installment_partial_number_mask(i.invoice.number, i.number)} \n "
    end
    SellerMailer.send(@method, @seller.users.first, @seller, installments_text).deliver_now
  end
end
