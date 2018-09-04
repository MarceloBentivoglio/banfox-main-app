class SellersController < ApplicationController
  before_action :set_user, only: [:dashboard, :analysis]
  before_action :set_seller, only: [:dashboard, :analysis]
  skip_before_action :require_not_on_going, only: [:analysis]

  def dashboard
    @seller.set_initial_limit
    @show_message = false
    verify_first_access
  end

  def analysis
    redirect_to unfortune_path and return unless CpfCheckRF.new(@seller).analyze
    redirect_to unfortune_path and return unless check_revenue
    @seller.pre_approved!
    redirect_to sellers_dashboard_path
  rescue Timeout::Error
    redirect_to takeabreath_path and return
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
