class AntiFraudInfoJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)
    IpAPIService.new(user).call
  end
end
