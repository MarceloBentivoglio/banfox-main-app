require 'test_helper'

class BillingRulerServiceTest < ActiveSupport::TestCase
  setup do
    using_shared_operation
    #ignore_slack_call
    Date.stubs(:today).returns(Date.new(2019, 9, 8))
  end

  test ".monthly_organization_mails_sender get installments that overdue that month and send them" do 
    seller_2 = FactoryBot.create(:seller, :seller_2)
    invoice = FactoryBot.create(:invoice, payer: @payer_1, seller: seller_2)
    installment = FactoryBot.create(:installment, invoice: invoice)
    installment.opened!
    sellers = [@seller, seller_2]
    #::SellerMailer.any_instance.expects(:monthly_organization)
    billing_ruler_service = BillingRulerService.new(sellers)
    assert_difference 'BillingRuler.count', +1 do
      billing_ruler_service.monthly_organization_mail_checker
    end
    assert_equal BillingRuler.last.billing_type, "monthly_organization"
  end

  test ".weekly_organization_mails_sender get installments that overdue that week and send them" do 
    seller_2 = FactoryBot.create(:seller, :seller_2)
    invoice = FactoryBot.create(:invoice, payer: @payer_1, seller: seller_2)
    installment = FactoryBot.create(:installment, invoice: invoice)
    installment.due_date = Date.today
    installment.opened!
    sellers = [@seller, seller_2]
    #::SellerMailer.any_instance.expects(:weekly_organization)
    billing_ruler_service = BillingRulerService.new(sellers)
    assert_difference 'BillingRuler.count', +1 do
      billing_ruler_service.weekly_organization_mail_checker
    end
    assert_equal BillingRuler.last.billing_type, "weekly_organization"
  end

  test ".due_date_mail_sender get installments that reached due_date and send them" do
    @installment_1.due_date = Date.today
    @installment_1.opened!
    sellers = [@seller]
    #::SellerMailer.any_instance.expects(:due_date)
    billing_ruler_service = BillingRulerService.new(sellers)
    assert_difference 'BillingRuler.count', +1 do
      billing_ruler_service.due_date_mail_checker
    end
    assert_equal BillingRuler.last.billing_type, "due_date"
  end

  test ".just_overdued_mail_sender get installments that overdued on the current day and send them" do
    @installment_1.due_date = Date.today - 4
    @installment_1.opened!
    sellers = [@seller]
    #::SellerMailer.any_instance.expects(:just_overdued)
    billing_ruler_service = BillingRulerService.new(sellers)
    assert_difference 'BillingRuler.count', +1 do
      billing_ruler_service.just_overdued_mail_checker
    end
    assert_equal BillingRuler.last.billing_type, "just_overdued"
  end

  test ".overdue_mail_sender get installments that are overdued from 5 to 9 days and send them" do
    @installment_1.due_date = Date.today - 9
    @installment_1.opened!
    sellers = [@seller]
    #::SellerMailer.any_instance.expects(:overdue)
    billing_ruler_service = BillingRulerService.new(sellers)
    assert_difference 'BillingRuler.count', +1 do
      billing_ruler_service.overdue_mail_checker
    end
    assert_equal BillingRuler.last.billing_type, "overdue"
  end

  test ".overdue_pre_serasa_mail_sender get installments that are overdued from 10 to 19 days and send them" do
    @installment_1.due_date = Date.today - 18
    @installment_1.opened!
    sellers = [@seller]
    #::SellerMailer.any_instance.expects(:overdue_pre_serasa)
    billing_ruler_service = BillingRulerService.new(sellers)
    assert_difference 'BillingRuler.count', +1 do
      billing_ruler_service.overdue_pre_serasa_mail_checker
    end
    assert_equal BillingRuler.last.billing_type, "overdue_pre_serasa"
  end

  test ".sending_to_serasa_mail_sender get installments that are overdued for 20 days and send them" do
    @installment_1.due_date = Date.today - 20
    @installment_1.opened!
    sellers = [@seller]
    #::SellerMailer.any_instance.expects(:sending_to_serasa)
    billing_ruler_service = BillingRulerService.new(sellers)
    assert_difference 'BillingRuler.count', +1 do
      billing_ruler_service.sending_to_serasa_mail_checker
    end
    assert_equal BillingRuler.last.billing_type, "sending_to_serasa"
  end

  test ".overdue_after_serasa_mail_sender get installments that are overdued from 21 to 29 days and send them" do
    @installment_1.due_date = Date.today - 24
    @installment_1.opened!
    sellers = [@seller]
    #::SellerMailer.any_instance.expects(:overdue_after_serasa)
    billing_ruler_service = BillingRulerService.new(sellers)
    assert_difference 'BillingRuler.count', +1 do
      billing_ruler_service.overdue_after_serasa_mail_checker
    end
    assert_equal BillingRuler.last.billing_type, "overdue_after_serasa"
  end

  test ".protest_mail_sender get installments that are overdued for 30 days and send them" do
    @installment_1.due_date = Date.today - 30
    @installment_1.opened!
    sellers = [@seller]
    #::SellerMailer.any_instance.expects(:protest)
    billing_ruler_service = BillingRulerService.new(sellers)
    assert_difference 'BillingRuler.count', +1 do
      billing_ruler_service.protest_mail_checker
    end
    assert_equal BillingRuler.last.billing_type, "protest"
  end
end
