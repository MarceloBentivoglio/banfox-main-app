class SignupService

  def self.call(params)
    user_params = {}
    seller_params = {}

    seller_params["full_name"] = params["full_name"]
    seller_params["mobile"] = params["mobile"]
    seller_params["cnpj"] = params["cnpj"]
    seller = Seller.new(seller_params)
    seller.no_a1!
    seller.save

    user_params["email"] = params["email"]
    user_params["password"] = params["password"]
    user = User.new(user_params)
    user.seller_id = seller.id
    user.save
    user
  end
end
