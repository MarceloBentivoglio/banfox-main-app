class Api::V1::BillingRulerResponsesController < Api::V1::BaseController
  add_template_helper(InfoMasksHelper)
 
  def paid
    #TODO
    #safe_params = params.permit()
    seller = Seller.find(id)
    installments = []
    installment_ids.map {|id| installments << Installment.find(id)}
    message_text = ""
    installments.each do |i|
      message_text += "#{invoice_installment_partial_number_mask(i.invoice.number, i.number)} \n "
    end
    SlackMessage.new("CPM2L0ESD", 
                     "<!channel> O cliente #{seller.full_name} informou que já pagou  os títulos:
                     #{message_text}"
                    ).send_now
  end

  def pending
    seller = Seller.find(id)
    installments = []
    installment_ids.map {|id| installments << Installment.find(id)}
    message_text = ""
    installments.each do |i|
      message_text += "#{invoice_installment_partial_number_mask(i.invoice.number, i.number)} \n "
    end
    SlackMessage.new("CPM2L0ESD", 
                     "<!channel> O cliente #{seller.full_name} informou que não pagou os títulos:
                     #{message_text}"
                    ).send_now
  end
end

