class WeeklyOrganizationCron
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform()
    if Date.today.day >= 4
      sellers = Seller.where(validation_status: "active", allowed_to_operate: true)
      billing_ruler_service = BillingRulerService.new(sellers)
      billing_ruler_service.weekly_organization_mail_checker
      SlackMessage.new("CPVKLBR3J", "<!channel> Olá! WeeklyOrganizationCron completou o seu processo.").send_now
    end
  end
end
