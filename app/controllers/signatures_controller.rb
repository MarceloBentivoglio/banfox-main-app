class SignaturesController < ApplicationController
  skip_before_action :authenticate_user!,   only: [:joint_debtor, :joint_debtor_d4sign]
  skip_before_action :require_active,       only: [:joint_debtor, :joint_debtor_d4sign]
  skip_before_action :require_permission_to_operate, only: [:joint_debtor, :joint_debtor_d4sign]
  skip_before_action :require_not_on_going, only: [:joint_debtor, :joint_debtor_d4sign]
  layout "application_for_non_users"

  def joint_debtor
    @signature_key = params[:signature_key]
    @redirection_url = new_feedbacks_url
  end

  def joint_debtor_d4sign
    safe_params = params.permit(:signature_key, :operation_id)
    @signature_key = safe_params[:signature_key]
    operation = Operation.find(safe_params[:operation_id])
    @document_uuid = operation.sign_document_key
    @email = ""
    operation.sign_document_info.each do |signer|
      @email = signer["email"] if signer["key_signer"] == @signature_key
    end
    @redirection_url = new_feedbacks_url
  end

end
