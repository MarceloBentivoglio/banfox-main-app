class BillingRulerCron
  include Sidekiq::Worker

  def perform()
    SlackMessage.new("CPM2L0ESD", "<!channel> Esse é o seu OLÁ diario do seu amigo cron =D").send_now 
  end
end
