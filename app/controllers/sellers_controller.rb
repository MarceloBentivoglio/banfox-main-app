class SellersController < ApplicationController
  def show
    @user = current_user
    @seller = @user.seller
  end
end
