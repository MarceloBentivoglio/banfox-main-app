class InstallmentsController < ApplicationController
  before_action :set_seller, only: [:store, :opened, :history]

  def store
    @installments = Installment.ordered_in_analysis(@seller).paginate(page: params[:page])
    @no_operation_in_analysis = false
    if @installments.empty?
      @installments = Installment.in_store(@seller).paginate(page: params[:page])
      @no_operation_in_analysis = true
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def opened
    @installments = Installment.currently_opened(@seller).paginate(page: params[:page])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def history
    @installments = Installment.finished(@seller).paginate(page: params[:page])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def destroy
    @installment = Installment.find(params[:id])
    authorize @installment
    @installment.destroy
    redirect_to store_installments_path
  end

  private

  def set_seller
    @seller = current_user.seller
  end
end
