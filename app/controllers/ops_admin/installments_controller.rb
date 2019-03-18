class OpsAdmin::InstallmentsController < ApplicationController
  def index
    @installments = Installment.ordered
  end
end
