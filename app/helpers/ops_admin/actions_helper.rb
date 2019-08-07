module OpsAdmin::ActionsHelper

  def ops_admin_actions(seller)
    edit_link(seller) + "|" + joint_debtor_link(seller) + "|" + checking_account_link(seller) + "|" + set_analysis_links(seller)
  end

  private

  def edit_link(seller)
    link_to "editar valores", edit_ops_admin_seller_path(seller)
  end

  def joint_debtor_link(seller)
    link_to "editar devedores solidários", ops_admin_seller_joint_debtors_path(seller)
  end

  def checking_account_link(seller)
    link_to "editar contas correntes", ops_admin_seller_checking_accounts_path(seller), id: "manage-checking-account"
  end

  def set_analysis_links(seller)
    if seller.on_going?
      return pre_approve_link(seller)
    elsif seller.pre_approved?
      return approve_link(seller) + "|" + reject_link(seller)
    elsif seller.approved?
      return forbid_to_operate(seller)
    else
      return ""
    end
  end

  def pre_approve_link(seller)
    link_to "pre-aprovar", pre_approve_ops_admin_seller_path(seller)
  end

  def reject_link(seller)
    link_to "rejeitar", reject_ops_admin_seller_path(seller)
  end

  def approve_link(seller)
    link_to "aprovar", approve_ops_admin_seller_path(seller)
  end

  def forbid_to_operate(seller)
    link_to "parar de operar", forbid_to_operate_ops_admin_seller_path(seller), {"data-confirm" => "Tem certeza?"}
  end


end
