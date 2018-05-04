class WizardsController < ApplicationController
  before_action :load_client_wizard, except: %i(validate_step)

  def validate_step
    current_step = params[:current_step]

    @client_wizard = wizard_client_for_step(current_step)
    @client_wizard.client.attributes = client_wizard_params
    session[:client_attributes] = @client_wizard.client.attributes

    if @client_wizard.valid?
      next_step = wizard_client_next_step(current_step)
      create and return unless next_step

      redirect_to action: next_step
    else
      render current_step
    end
  end

  def create
    if @client_wizard.client.save
      session[:client_attributes] = nil
      redirect_to root_path, notice: 'Client succesfully created!'
    else
      redirect_to({ action: Wizard::Client::STEPS.first }, alert: 'There were a problem when creating the client.')
    end
  end

  private

  def load_client_wizard
    @client_wizard = wizard_client_for_step(action_name)
  end

  def wizard_client_next_step(step)
    Wizard::Client::STEPS[Wizard::Client::STEPS.index(step) + 1]
  end

  def wizard_client_for_step(step)
    raise InvalidStep unless step.in?(Wizard::Client::STEPS)

    "Wizard::Client::#{step.camelize}".constantize.new(session[:client_attributes])
  end

  def client_wizard_params
    params.require(:client_wizard).permit(:full_name, :company_name, :cpf, :cnpj)
  end

  class InvalidStep < StandardError; end
end
