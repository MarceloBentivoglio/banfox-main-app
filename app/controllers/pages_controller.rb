class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :billing_ruler_paid, :billing_ruler_pending, :billing_ruler_not_found]
  skip_before_action :require_active, only: [:home, :unfortune, :take_a_breath, :billing_ruler_paid, :billing_ruler_pending, :billing_ruler_not_found]
  skip_before_action :require_permission_to_operate, only: [:home, :unfortune, :take_a_breath, :billing_ruler_paid, :billing_ruler_pending, :billing_ruler_not_found]
  skip_before_action :require_not_on_going, only: [:home, :unfortune, :take_a_breath, :billing_ruler_paid, :billing_ruler_pending, :billing_ruler_not_found]
  before_action :require_on_going, only: [:take_a_breath]
  before_action :require_rejected, only: [:unfortune]
  before_action :set_user_and_seller, only: [:unfortune, :take_a_breath]
  layout :resolve_layout

  def home
    @redirection_options = {situation: "register"}
    if user_signed_in?
      if (seller = current_user.seller)
        if seller.active?
          @redirection_options[:situation] = "active"
          @redirection_options[:path] = store_installments_path
        else
          @redirection_options[:situation] = "incomplete"
          @redirection_options[:path] = "#{seller_steps_path}/#{seller.next_step}"
        end
      else
        @redirection_options[:situation] = "begin"
        @redirection_options[:path] = seller_steps_path
      end
    end
  end

  def unfortune
  end

  def take_a_breath
  end

  private

  def resolve_layout
    case action_name
    when "billing_ruler_not_found", "billing_ruler_paid", "billing_ruler_pending"
      "application_for_non_users"
    else
      "homelayout"
    end
  end

  def set_user_and_seller
    @user = current_user
    @seller = @user.seller
  end

  def require_on_going
    if (seller = current_user.seller)
      if !seller.on_going?
        redirect_to root_path
      end
    end
  end

  def require_rejected
    if (seller = current_user.seller)
      if !seller.rejected?
        redirect_to root_path
      end
    end
  end

end
