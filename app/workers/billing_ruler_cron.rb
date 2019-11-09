class BillingRulerCron
  include Sidekiq::Worker

  def perform()
    sellers = Seller.where(validation_status: "active", allowed_to_operate: true)
    billing_ruler_service = BillingRulerService.new(sellers)
    billing_ruler_service.daily_billing_mail_sender
  end
end
