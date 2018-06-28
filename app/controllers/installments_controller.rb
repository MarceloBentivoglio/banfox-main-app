class InstallmentsController < ApplicationController
  def destroy
    @isntallment = Installment.find(params[:id])
    @isntallment.destroy
    redirect_to store_operations_path
  end
end
