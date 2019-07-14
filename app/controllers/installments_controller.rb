class InstallmentsController < ApplicationController
  before_action :set_seller, only: [:store, :opened, :history]
  before_action :set_operation_and_status, only: [:store]
  before_action :verify_need_immediate_upload, only: [:store]

  layout "application_w_flashes"

  def store
    @installments_lacking_information = Installment.in_store_lacking_information(@seller)
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

  def update
    Installment.update(installment_params)
    @i = Installment.find(params[:id])
    ninety_days = 90.days.since.to_date
    @i.backoffice_status = ((@i.due_date <= Date.current) || (@i.due_date > ninety_days)) ? :unavailable : :available
    @i.unavailability = set_unavailability(@i.due_date, ninety_days)
    @i.save!
    redirect_to store_installments_path

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

  def set_operation_and_status
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

  def verify_need_immediate_upload
    @show_message = false
    if session["accessed"] == "operations.consent"
      session["accessed"] = "installments.store"
      @show_message = true
    end
  end

  def installment_params
    params.require(:installment).permit(:due_date)
  end

  def set_unavailability (due_date, ninety_days)
    return :due_date_past if due_date <= Date.current
    return :due_date_later_than_limit if due_date > ninety_days
    return :unavailability_non_applicable
  end

end
