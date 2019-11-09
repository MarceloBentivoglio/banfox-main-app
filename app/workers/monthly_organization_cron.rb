class MonthlyOrganizationCron
  include Sidekiq::Worker

  def perform()
    sellers = Seller.where(validation_status: "active", allowed_to_operate: true)
    billing_ruler_service = BillingRulerService.new(sellers)
    billing_ruler_service.monthly_organization_mail_sender
  end
end
