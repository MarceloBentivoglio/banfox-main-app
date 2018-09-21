class OperationsController < ApplicationController
  before_action :no_operation_in_analysis, only: [:create]

  def create
    operation = Operation.new(operation_params)
    if operation.installments.all? { |i| i.available? }
      ActiveRecord::Base.transaction do
        operation.save!
        operation.installments.each do |i|
          i.ordered!
        end
      end
    end
    redirect_to store_installments_path
  rescue
   redirect_to store_installments_path
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


end
