class KeyIndicatorReportsController < ActionController::Base
  def login
    @user = User.new
  end

  def authenticate
    begin
      @user = User.find_by(email: params[:user][:email])
      if @user.valid_password?(user_params[:password])
        sign_in :user, @user

        redirect_to new_ops_admin_key_indicator_report_path
      end
    rescue Exception => e
      Rollbar.error(e)
      @user = User.new(user_params)
      render :sign_in
    end
  end

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
