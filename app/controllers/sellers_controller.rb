class SellersController < ApplicationController
  def show
    @user = current_user
    @seller = @user.seller
    @seller.set_initial_limit
    @show_message = false
    verify_first_access
  end

  private

  def verify_first_access
    if session["accessed"] == "consent"
      session["accessed"] = "seller_show"
      @show_message = true
    end
  end
end
