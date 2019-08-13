class OpsAdmin::CheckingAccountsController < OpsAdmin::BaseController
  before_action :set_seller, only: [:index, :new, :create, :edit, :update, :destroy]
  before_action :set_checking_account, only: [:edit, :update, :destroy]

  def index
    @checking_accounts = @seller.checking_accounts
  end

  def new
    @checking_account = CheckingAccount.new()
  end

  def create
    @checking_account = CheckingAccount.new(checking_account_params)
    @checking_account.seller = @seller
    select_result = Bank::BANK_INFO.select {|key, hash| key[:code] == @checking_account.bank_code }
    @checking_account.bank_name = select_result[0][:name] unless select_result.blank?
    if @checking_account.save
      redirect_to ops_admin_seller_checking_accounts_path(@seller)
    else
      render :new
    end
  end

  def edit
  end

  def update
    new_checking_account_params = checking_account_params
    unless @checking_account.bank_code == checking_account_params[:bank_code]
      select_result = Bank::BANK_INFO.select {|key, hash| key[:code] == new_checking_account_params[:bank_code] }
      new_checking_account_params[:bank_name] = select_result[0][:name] unless select_result.blank?
    end
    if @checking_account.update(new_checking_account_params)
      redirect_to ops_admin_seller_checking_accounts_path(@seller)
    else
      render :edit
    end
  end

  def destroy
    authorize @checking_account
    @checking_account.destroy
    redirect_to ops_admin_seller_checking_accounts_path(@seller)
  end

  private

  def set_seller
    @seller = Seller.find(params[:seller_id])
  end

  def set_checking_account
    @checking_account = CheckingAccount.find(params[:id])
  end

  def checking_account_params
    params.require(:checking_account).permit(:seller_id, :document, :name, :account_number, :branch, :bank_code, :bank_name)
  end
end
