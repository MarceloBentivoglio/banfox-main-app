class ContactsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]
  skip_before_action :require_active, only: [:new, :create]
  skip_before_action :require_not_rejected, only: [:new, :create]
  skip_before_action :require_not_on_going, only: [:new, :create]

layout "homelayout"

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(params[:contact])
    @contact.request = request
    if @contact.deliver
      flash.now[:notice] = 'Obrigado pela mensagem, entraremos em contato em breve.'
      redirect_to root_path
    else
      flash.now[:error] = 'Não foi possível enviar a sua mensagem.'
      render :new
    end
  end
end
