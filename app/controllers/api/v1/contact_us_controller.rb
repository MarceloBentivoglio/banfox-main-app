class Api::V1::ContactUsController < Api::V1::BaseController
  def lp_contact
    safe_params = params.permit(:name, :phone, :email, :message)
    message = "*Nome:* #{safe_params[:name]} \n *Telefone:* #{safe_params[:phone]} \n *E-mail:* #{safe_params[:email]} \n *Mensagem:* #{safe_params[:message]}"
    SlackMessage.new("CQPECL1B3", "<!channel> Um contato foi enviado: \n #{message}").send_now
  end
end
