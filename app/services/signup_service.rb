class SignupService
  def self.call(params)
    new.call(params)
  end

  def call(params)
    seller = Seller.new(seller_params(params))
    seller.with_a1!

    user = User.new(user_params(params))
    user.seller_id = seller.id

    [seller, user]
  end

  def user_params(params)
    params.permit(:email, :password)
  end

  def seller_params(params)
    params.permit(:full_name, :mobile, :cnpj)
  end
end
