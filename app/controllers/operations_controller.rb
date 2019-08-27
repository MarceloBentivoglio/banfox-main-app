class OperationsController < ApplicationController
  before_action :no_operation_in_analysis, only: [:create]
  before_action :set_seller, only: [:create, :consent, :create_document, :create_document_d4sign, :sign_document, :cancel]

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
        #TODO transform all deliver_now in deliver later
        OperationMailer.to_analysis(operation, current_user, @seller).deliver_now
        SlackMessage.new("CEPB65532", "<!channel> #{@seller.company_name.titleize} \n cnpj: #{@seller.cnpj} subiu uma operação nova de número *##{operation.id}*").send_now
      end
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
    @operation = Operation.last_from_seller(@seller).last
    @operation.sign_document_requested_at = Time.current
    sign_documents = SignDocuments.new(@operation, @seller)
    @operation.sign_document_info = sign_documents.sign_document_info
    @operation.sign_document_key = sign_documents.sign_document_key
    @operation.save!
    @operation.notify_joint_debtors(@seller)
    @operation.notify_banfox_signer
    redirect_to sign_document_operations_path
  end

  def create_document_d4sign
    @operation = Operation.last_from_seller(@seller).last
    @operation.sign_document_requested_at = Time.current
    d4sign = D4Sign.new(@operation, @seller)
    @operation.sign_document_key = d4sign.send_document
    @operation.sign_document_info = d4sign.add_signer_list(@operation.sign_document_key, @seller)
    d4sign.send_to_sign(@operation.sign_documetn_key)
    @operation.save!
    redirect_to sign_document_operations_path
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
