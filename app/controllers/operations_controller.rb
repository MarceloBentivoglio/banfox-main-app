class OperationsController < ApplicationController
  before_action :no_operation_in_analysis, only: [:create]
  before_action :set_seller, only: [:create, :consent, :create_document, :create_document_d4sign, :sign_document, :sign_document_d4sign, :cancel]
  before_action :set_operation, only: [:create_document, :create_document_d4sign]

  layout "application_w_flashes"

  def create
    #TODO make this verification on a service
    flash[:alert] = []
    operation = Operation.new(operation_params)
    if operation.installments.all? { |i| i.available? } && operation.installments.reduce(0) {|sum, i| sum + i.value } <= @seller.available_limit
      ActiveRecord::Base.transaction do
        operation.installments.each do |i|
          i.ordered_at = Time.current
          i.ordered!
        end
        operation.save!
        #TODO transform all deliver_now in deliver later
        OperationMailer.to_analysis(operation, current_user, @seller).deliver_now
        SlackMessage.new("CEPB65532", "<!channel> #{@seller.company_name.titleize} \n cnpj: #{@seller.cnpj} subiu uma operação nova de número *##{operation.id}*").send_now
        Risk::Service::KeyIndicatorReportRequest.call({cnpjs: nil, operation_id: operation.id})
      end
    else
      flash[:alert] << "A soma das parcelas excede o seu limite operacional."
    end
    redirect_to store_installments_path
    #TODO never fails silently
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
    @operation.sign_document_requested_at = Time.current
    @operation.set_used_balance!
    @operation.started!
    sign_documents = SignDocuments.new(@operation, @seller)
    sign_documents.call
    @operation.sign_document_info = sign_documents.sign_document_info
    @operation.sign_document_key = sign_documents.sign_document_key
    @operation.save!
    @operation.completed!
    @operation.notify_joint_debtors(@seller)
    @operation.notify_banfox_signer
    redirect_to sign_document_operations_path
  end

  def create_document_d4sign
    @operation.set_used_balance!
    @operation.started!
    CreateDocumentJob.perform_now(@operation, @seller)
    redirect_to sign_document_d4sign_operations_path
  end

  def sign_document
    operation = Operation.last_from_seller(@seller).last
    signer_signature_keys = operation.signer_signature_keys
    main_signer_signature_key = signer_signature_keys.find do |signer_signature_key|
      signer_signature_key[:email] == @seller.email_partner
    end
    @signature_key = main_signer_signature_key[:signature_key]
    @redirection_url = store_installments_url
  end

  def sign_document_d4sign
    operation = Operation.last_from_seller(@seller).last
    main_key_signer = operation.sign_document_info.find do |key_signer|
      key_signer["email"] == @seller.email_partner
    end
    @signature_key = main_key_signer["key_signer"]
    @redirection_url = store_installments_url
    @document_uuid = operation.sign_document_key
  end

  def cancel
    flash[:alert] = []
    operation_id = params[:id]
    operation = Operation.find(operation_id)
    installments = operation.installments
    installments.each do |installment|
      installment.ordered_at = nil
      installment.operation = nil
      installment.available!
    end
    operation.destroy
    SlackMessage.new("CM0HURWU9", "<!channel> #{@seller.company_name.titleize} \n cnpj: #{@seller.cnpj} *cancelou* a operação *##{operation_id}*").send_now
    flash[:alert] << "Operação cancelada com sucesso!"
    redirect_to store_installments_path
  end

  def check_sign_document_status
    operations_params = params.permit(:id)
    @operation = Operation.find(operations_params["id"])
    render :json => @operation.sign_document_status
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

  def set_operation
    @operation = Operation.last_from_seller(@seller).last
  end

end
