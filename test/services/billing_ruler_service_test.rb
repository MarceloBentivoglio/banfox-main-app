require 'test_helper'

class BillingRulerServiceTest < ActiveSupport::TestCase
  setup do
    using_shared_operation
  end

  test ".monthly_organization_mails_sender get installments that overdue that month and send them" do 
    seller_2 = FactoryBot.create(:seller, :seller_2)
    invoice = FactoryBot.create(:invoice, payer: @payer_1, seller: seller_2)
    installment = FactoryBot.create(:installment, invoice: invoice)
    installment.opened!
    sellers = [@seller, seller_2]
    Date.stubs(:today).returns(Date.new(2019, 9, 8))
    ::SellerMailer.any_instance.expects(:monthly_organization)
    billing_ruler_service = BillingRulerService.new(sellers)
    billing_ruler_service.monthly_organization_mail_sender
  end

  test ".weekly_organization_mails_sender get installments that overdue that week and send them" do 
    seller_2 = FactoryBot.create(:seller, :seller_2)
    invoice = FactoryBot.create(:invoice, payer: @payer_1, seller: seller_2)
    installment = FactoryBot.create(:installment, invoice: invoice)
    installment.due_date = Date.new(2019, 9, 8)
    installment.opened!
    sellers = [@seller, seller_2]
    Date.stubs(:today).returns(Date.new(2019, 9, 8))
    ::SellerMailer.any_instance.expects(:weekly_organization)
    billing_ruler_service = BillingRulerService.new(sellers)
    billing_ruler_service.weekly_organization_mail_sender
  end

end
