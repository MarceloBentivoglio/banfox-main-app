class OperationsController < ApplicationController

  def create
    operation = Operation.new(operation_params)
    ActiveRecord::Base.transaction do
      operation.save!
      operation.installments.each do |i|
        i.ordered!
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


end
