class SellersController < ApplicationController
  before_action :set_user, only: [:dashboard, :analysis]
  before_action :set_seller, only: [:dashboard, :analysis]
  skip_before_action :require_not_on_going, only: [:analysis]

  def dashboard
    @show_message = false
    verify_first_access
    @installments_in_analysis = Installment.total(:in_analysis, @seller)
  end

  #TODO refactor with service layers
  def analysis
    if !CreditAnalysis::CpfCheckRF.new(@seller).analyze
      @seller.rejected!
      @seller.allowed_to_operate = false
      @seller.forbad_to_operate_at = Time.current
      @seller.auto_veredict_at = Time.current
      @seller.save!
      SellerMailer.rejected(@user, @seller).deliver_now

      #We will not reject a seller for insufficient revenue, that's why check_revenue was removed
      if @seller.rejection_motive == "insuficient_revenue"
        SlackMessage.new("CC2NP6XHN", "<!channel> #{@seller.company_name.titleize} \n cnpj: #{@seller.cnpj} acabou de se cadastrar e foi *rejeitado* automaticamente por #{@seller.rejection_motive} \n Receita: #{@seller.monthly_revenue_cents&.fdiv(100)} \n Nome: #{@seller.full_name}; Telefone: #{@seller.mobile}; Email: #{@seller.users.first.email} \n Partner: #{@seller.full_name_partner}; Telefone: #{@seller.mobile_partner}; Email: #{@seller.email_partner}").send_now
      else
        SlackMessage.new("CC2NP6XHN", "<!channel> #{@seller.company_name.titleize} \n cnpj: #{@seller.cnpj} acabou de se cadastrar e foi *rejeitado* automaticamente por #{@seller.rejection_motive}").send_now
      end
      redirect_to unfortune_path and return
    end
    @seller.pre_approved!
    @seller.set_operation_limit
    @seller.set_pre_approved_initial_standard_settings
    @seller.auto_veredict_at = Time.current
    @seller.allowed_to_operate = true
    @seller.save!
    SellerMailer.welcome(@user, @seller).deliver_now
    SlackMessage.new("CC2NP6XHN", "<!channel> #{@seller.company_name.titleize} \n cnpj: #{@seller.cnpj} acabou de se cadastrar e foi *pré-aprovado*").send_now
    redirect_to sellers_dashboard_path
  rescue StandardError => e
    SlackMessage.new("CH1KSHZ2T", "Someone tried to finish seller_steps but had a problem in the analysis \n Erro: #{e.message}").send_now
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
