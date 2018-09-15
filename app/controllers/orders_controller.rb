class OrdersController < ApplicationController
  def create
    order = Order.new(order_params)
    order.save!
    redirect_to invoices_store_path
  end

  private

  def order_params
    params.require(:order).permit(installment_ids: [])
  end
end
