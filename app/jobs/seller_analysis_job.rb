class SellerAnalysisJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)

    SellerAnalysis.call(user, user.seller)
  end
end
