class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :howitworks]

  def home
    @redirection_options = {situation: "register"}
    if user_signed_in?
      if (seller = current_user.seller)
        if seller.active?
          @redirection_options[:situation] = "active"
          @redirection_options[:path] = invoices_path
        else
          @redirection_options[:situation] = "incomplete"
          @redirection_options[:path] = "#{seller_steps_path}/#{seller.next_step}"
        end
      else
        @redirection_options[:situation] = "begin"
        @redirection_options[:path] = seller_steps_path
      end
    end


    render layout: "homelayout"
  end

  def howitworks
    render layout: "homelayout"
  end
end
