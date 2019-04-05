class OperationsController < ApplicationController
  before_action :no_operation_in_analysis, only: [:create]
  before_action :set_seller, only: [:create, :consent, :create_document, :sign_document, :update]

  layout "application_w_flashes"

  def create
    operation = Operation.new(operation_params)
    if operation.installments.all? { |i| i.available? } && operation.installments.reduce(0) {|sum, i| sum + i.value } <= @seller.available_limit
      ActiveRecord::Base.transaction do
        operation.installments.each do |i|
          i.ordered_at = Time.current
          i.ordered!
        end
        operation.save!
        OperationMailer.to_analysis(operation, current_user, @seller).deliver_now
        SlackMessage.new("CEPB65532", "<!channel> #{@seller.company_name} \n cnpj: #{@seller.cnpj} subiu uma operação nova").send_now
      end
    end
    redirect_to store_installments_path
    rescue
      redirect_to store_installments_path
  end

  def consent
    operation = Operation.last_from_seller(@seller).last
    if operation.completely_rejected?
      operation.consent_rejection!
      session["accessed"] = "operations.consent"
      redirect_to store_installments_path
    end
  end

  def destroy
    @operation = Operation.find(params[:id])
    authorize @operation
    @operation.destroy
    redirect_to store_installments_path
  end

  def create_document
    @operation = Operation.last_from_seller(@seller).last
    sign_documents = SignDocuments.new(@operation, @seller)
    @operation.signature_keys = sign_documents.signature_keys
    @operation.sign_document_key = sign_documents.sign_document_key
    @operation.save!
    redirect_to sign_document_operations_path
  end

  def sign_document
    operation = Operation.last_from_seller(@seller).last
    @signature_key = operation.signature_keys["signature_keys"][0]["signature_key"]
    @redirection_url = store_installments_url
  end

  private

  def operation_params
    params.require(:operation).permit(:consent, installment_ids: [])
  end

  def no_operation_in_analysis
    Installment.ordered_in_analysis(current_user.seller).empty?
  end

  def set_seller
    @seller = current_user.seller
  end
end
