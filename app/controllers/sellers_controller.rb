class SellersController < ApplicationController
  def show
    @user = current_user
    @seller = @user.seller
    @documents_ok = @seller.documentation_completed?
    @at_leat_one_invoice = @seller.invoices.count > 0
    @visited = @seller.visited?
    if @seller.approved?

    end
  end
end
