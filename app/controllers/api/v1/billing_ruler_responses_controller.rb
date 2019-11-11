class Api::V1::BillingRulerResponsesController < ActionController::API
  #TODO add a way to identify user without the billing ruler to
  #make it easier to find possible bugs when code isnt found

  def paid
    safe_params = params.permit(:id)
    billing_ruler = BillingRuler.where(code: safe_params[:id], status: 0).first
    if billing_ruler.nil?
      SlackMessage.new("CPM2L0ESD", 
                       "<!channel> Um cliente tentou informar que já pagou os títulos porém o código de resposta: *#{safe_params[:id]}* não foi encontrado.").send_now
      redirect_to billing_ruler_not_found_path
    else
      message_text = ""
      installments = billing_ruler.installments
      unless installments.nil?
        installments.each do |i|
          message_text += "#{i.invoice&.number}/#{i.number} \n "
        end
      end
      billing_ruler.paid!
      SlackMessage.new("CPM2L0ESD", 
                       "<!channel> O cliente #{billing_ruler.seller&.full_name} informou que já pagou os títulos: \n #{message_text}").send_now
      redirect_to billing_ruler_paid_path
    end
  end

  def pending
    safe_params = params.permit(:id)
    billing_ruler = BillingRuler.where(code: safe_params[:id], status: 0).first
    if billing_ruler.nil?
      SlackMessage.new("CPM2L0ESD", 
                       "<!channel> Um cliente tentou informar que não pagou os títulos porém o código de resposta: *#{safe_param[:id]}* não foi encontrado").send_now
      redirect_to billing_ruler_not_found_path
    else
      message_text = ""
      installments = billing_ruler.installments
      unless installments.nil?
        installments.each do |i|
          message_text += "#{i.invoice&.number}/#{i.number} \n "
        end
      end
      billing_ruler.pending!
      SlackMessage.new("CPM2L0ESD", 
                       "<!channel> O cliente #{billing_ruler.seller&.full_name} informou que não pagou os títulos: \n #{message_text}").send_now
      redirect_to billing_ruler_pending_path
    end
  end
end
