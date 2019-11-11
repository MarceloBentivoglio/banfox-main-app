class WeeklyOrganizationCron
  include Sidekiq::Worker

  def perform()
    if Date.today.day >= 4
      sellers = Seller.where(validation_status: "active", allowed_to_operate: true)
      billing_ruler_service = BillingRulerService.new(sellers)
      billing_ruler_service.weekly_organization_mail_sender
    end
  end
end
