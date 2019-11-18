class IpAPIService
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def call
    data = RestClient.get(url)
    AntiFraudInfo.create(user: user, ip_api: data)
  end

  def url
    "http://ip-api.com/json/#{@user.remote_original_ip}"
  end
end
