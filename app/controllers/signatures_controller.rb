class SignaturesController < ApplicationController
  skip_before_action :authenticate_user!,   only: [:joint_debtor]
  skip_before_action :require_active,       only: [:joint_debtor]
  skip_before_action :require_permission_to_operate, only: [:joint_debtor]
  skip_before_action :require_not_on_going, only: [:joint_debtor]
  layout "application_for_non_users"

  def joint_debtor
    @signature_key = params[:signature_key]
    @redirection_url = store_installments_url
  end








end
