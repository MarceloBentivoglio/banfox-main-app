class OperationsController < ApplicationController
  before_action :no_operation_in_analysis, only: [:create]
  before_action :set_seller, only: [:create, :consent]

  def create
    operation = Operation.new(operation_params)
    if operation.installments.all? { |i| i.available? } && operation.installments.reduce(0) {|sum, i| sum + i.value } <= @seller.available_limit
      ActiveRecord::Base.transaction do
        operation.save!
        operation.installments.each do |i|
          i.row = Installment.number_of_new_row
          i.ordered!
          i.async_update_spreadsheet
        end
        OperationMailer.to_analysis(operation, current_user, @seller).deliver_now
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
