class SellersController < ApplicationController
  def show
    @user = current_user
    @seller = @user.seller
    @seller.set_initial_limit
  end
end
