class SellersController < ApplicationController
  before_action :set_user, only: [:dashboard, :analysis]
  before_action :set_seller, only: [:dashboard, :analysis]

  def dashboard
    @seller.set_initial_limit
    @show_message = false
    verify_first_access
  end

  def analysis
    redirect_to unfortune_path and return unless check_revenue
    #TODO: check if User name is the same in Receita Federal
    @seller.pre_approved!
    redirect_to sellers_dashboard_path
  end

  private

  def set_user
    @user = current_user
  end

  def set_seller
    @seller = @user.seller
  end

  def check_revenue
    if @seller.active? && @seller.monthly_revenue < Money.new(10000000)
      @seller.rejected!
      @seller.insuficient_revenue!
      return false
    end
    return true
  end

  def verify_first_access
    if session["accessed"] == "consent"
      session["accessed"] = "seller_show"
      @show_message = true
    end
  end
end
