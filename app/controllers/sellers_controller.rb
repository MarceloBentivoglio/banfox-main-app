class SellersController < ApplicationController
  before_action :set_user, only: [:dashboard, :analysis]
  before_action :set_seller, only: [:dashboard, :analysis]
  skip_before_action :require_not_on_going, only: [:analysis]

  def dashboard
    @seller.set_initial_limit
    @show_message = false
    verify_first_access
    @installments_in_analysis = Installment.total(:in_analysis, @seller)

  end

  def analysis
    if !CpfCheckRF.new(@seller).analyze || !check_revenue
      SellerMailer.rejected(@user, @seller).deliver_now
      redirect_to unfortune_path and return
    end
    @seller.pre_approved!
    @seller.fator = 0.045
    @seller.advalorem = 0.005
    @seller.save!
    SellerMailer.welcome(@user, @seller).deliver_now
    SlackMessage.new("CC2NP6XHN", "<!channel> #{@seller.company_name} \n cnpj: #{@seller.cnpj} acabou de se cadastrar").send_now
    redirect_to sellers_dashboard_path
  rescue Timeout::Error
    SlackMessage.new("CH1KSHZ2T", "Someone tried to finish seller_steps but had a problem in the analysis").send_now
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
