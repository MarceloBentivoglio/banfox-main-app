class InstallmentsController < ApplicationController
  before_action :set_seller, only: [:store, :opened, :history]
  before_action :set_status, only: [:store]

  def store
    @installments = set_installments(@seller, @operation, @status).paginate(page: params[:page])
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

  def set_status
    @operation = Operation.last_from_seller(@seller).last || Operation.new
    @status = @operation.status[0]
  end

  def set_installments(seller, operation, status)
    case status
      when :no_on_going_operation
        Installment.in_store(@seller)
      else
        operation.installments
    end
  end
end
