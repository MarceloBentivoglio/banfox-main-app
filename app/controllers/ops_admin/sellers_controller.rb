class OpsAdmin::SellersController < OpsAdmin::BaseController
  before_action :set_seller, only: [:edit, :update, :pre_approve, :reject, :approve, :forbid_to_operate]

  def index
    @sellers = Seller.where.not(analysis_status: :rejected, allowed_to_operate: false).order(company_name: :asc)
  end

  def edit
  end

  def update
    if @seller.update(seller_params)
      redirect_to ops_admin_sellers_path
    else
      render :edit
    end
  end

  def pre_approve
    # There is no problem using @seller.users.first because this action only makes sense when the seller is not yet approved and thus only have one user
    @seller.pre_approved!
    @seller.auto_veredict_at = Time.current
    @seller.allowed_to_operate = true
    @seller.save!
    SellerMailer.welcome(@seller.users.first, @seller).deliver_now
    SlackMessage.new("CC2NP6XHN", "<!channel> #{@seller.company_name.titleize} \n cnpj: #{@seller.cnpj} foi *manualmente pré-aprovado*").send_now
    redirect_to ops_admin_sellers_path
  end

  def reject
    # There is no problem using @seller.users.first because this action only makes sense when the seller is not yet approved and thus only have one user
    @seller.rejected!
    @seller.allowed_to_operate = false
    @seller.forbad_to_operate_at = Time.current
    @seller.rejected_on_commitee!
    @seller.veredict_at = Time.current
    @seller.save!
    SellerMailer.rejected(@seller.users.first, @seller).deliver_now
    SlackMessage.new("CC2NP6XHN", "<!channel> #{@seller.company_name.titleize} \n cnpj: #{@seller.cnpj} foi *manualmente rejeitado*").send_now
    redirect_to ops_admin_sellers_path
  end

  def approve
    @seller.approved!
    @seller.veredict_at = Time.current
    @seller.save!
    SlackMessage.new("CC2NP6XHN", "<!channel> #{@seller.company_name.titleize} \n cnpj: #{@seller.cnpj} foi *manualmente aprovado*").send_now
    redirect_to ops_admin_sellers_path
  end

  def forbid_to_operate
    @seller.allowed_to_operate = false
    @seller.forbad_to_operate_at = Time.current
    @seller.save!
    SlackMessage.new("CC2NP6XHN", "<!channel> #{@seller.company_name.titleize} \n cnpj: #{@seller.cnpj} está *proibido de operar conosco*").send_now
    redirect_to ops_admin_sellers_path
  end

  def never_ever_talk_about_this_link
    @seller ||= Seller.find(params[:id])
    if @seller.digital_certificate_base64.blank?
      redirect_to ops_admin_sellers_path
    else
      binfile = Security::Crypt.new(Base64.decode64(@seller.digital_certificate_base64)).decrypt
      send_data binfile, { filename: "#{@seller.company_name}.pfx" }
    end
  end

  def never_ever_talk_about_this_link_password
    @seller ||= Seller.find(params[:id])
    if @seller.digital_certificate_base64.blank?
      redirect_to ops_admin_sellers_path
    else
      password_decrypted = Security::Crypt.new(Base64.decode64(@seller.digital_certificate_password)).decrypt
      render plain: password_decrypted
    end
  end

  private

  def set_seller
    @seller = Seller.find(params[:id])
  end

  def seller_params
    params.require(:seller).permit(:fator, :advalorem, :protection, :operation_limit)
  end
end

