class OverdueAfterSerasaCron
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform()
    sellers = Seller.where(validation_status: "active", allowed_to_operate: true)
    billing_ruler_service = BillingRulerService.new(sellers)
    billing_ruler_service.overdue_after_serasa_mail_checker
    SlackMessage.new("CPVKLBR3J", "<!channel> Olá! OverdueAfterSerasaCron completou o seu processo.").send_now
  end
end
