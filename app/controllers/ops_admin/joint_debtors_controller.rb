class OpsAdmin::JointDebtorsController < OpsAdmin::BaseController
  before_action :set_seller, only: [:index, :new, :create, :edit, :update]
  before_action :set_joint_debtor, only: [:edit, :update, :destroy]

  def index
    @joint_debtors = @seller.joint_debtors
  end

  def new
    @joint_debtor = JointDebtor.new
  end

  def create
    @joint_debtor = JointDebtor.new(joint_debtor_params)
    @joint_debtor.seller = @seller
    if @joint_debtor.save
      redirect_to ops_admin_seller_joint_debtors_path(@seller)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @joint_debtor.update(joint_debtor_params)
      redirect_to ops_admin_seller_joint_debtors_path(@seller)
    else
      render :edit
    end
  end

  def destroy
    @joint_debtor.destroy
    redirect_to ops_admin_seller_joint_debtors_path(@seller)
  end

  private

  def set_seller
    @seller = Seller.find(params[:seller_id])
  end

  def set_joint_debtor
    @joint_debtor = JointDebtor.find(params[:id])
  end

  def joint_debtor_params
    params.require(:joint_debtor).permit(:name, :birthdate, :mobile, :documentation, :email)

  end
end
