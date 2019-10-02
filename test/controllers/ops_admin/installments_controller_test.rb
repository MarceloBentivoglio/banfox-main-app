require 'test_helper'

class OpsAdmin::InstallmentControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    using_shared_operation
    sign_in FactoryBot.create(:user, :auth_admin, seller: @seller)

    def setting_mail
      ActionMailer::Base.mail(to: [@seller.users.first.email, @seller.email_partner], from: 'test@mail.com', subject: 'Sua parcela foi liquidada!', body: "")
    end
  end

  test '.report_paid send a "payment received" mail to seller' do
    mail_test = setting_mail
    installment_paid = FactoryBot.create(:installment, :paid, invoice: @invoice_1)
    Time.stubs(:current).returns(installment_paid.finished_at)
    InstallmentMailer.expects(:paid).with(installment_paid, @seller.users.first, @seller).returns(mail_test)
    assert_difference 'ActionMailer::Base.deliveries.count', +1 do
      get report_paid_ops_admin_installment_path(installment_paid)
    end
  end

  test '.report_paid send a "overdue payment received" mail to seller' do
    mail_test = setting_mail
    installment_paid_overdue = FactoryBot.create(:installment, :paid_overdue, invoice: @invoice_1)
    Time.stubs(:current).returns(installment_paid_overdue.finished_at)
    InstallmentMailer.expects(:paid_overdue).with(installment_paid_overdue, @seller.users.first, @seller).returns(mail_test)
    assert_difference 'ActionMailer::Base.deliveries.count', +1 do
      get report_paid_ops_admin_installment_path(installment_paid_overdue)
    end
  end

  test '.report_paid send a "ahead payment received" mail to seller' do
    mail_test = setting_mail
    installment_paid_ahead = FactoryBot.create(:installment, :paid_ahead, invoice: @invoice_1)
    Time.stubs(:current).returns(installment_paid_ahead.finished_at)
    InstallmentMailer.expects(:paid_ahead).with(installment_paid_ahead, @seller.users.first, @seller).returns(mail_test)
    assert_difference 'ActionMailer::Base.deliveries.count', +1 do
      get report_paid_ops_admin_installment_path(installment_paid_ahead)
    end
  end

  # TODO make this tests work
  # test '.report_paid create a Balance record for installment overdue' do
  #   assert_difference 'Balance.count', +1  do
  #     get report_paid_ops_admin_installment_path(@installment_1)
  #   end
  # end

  #   test '.report_paid create a Balance record for installment paid in advance' do
  #   assert_difference 'Balance.count', +1  do
  #     get report_paid_ops_admin_installment_path(@installment_1)
  #   end
  # end

  #TODO change this test for Balance
  # test '.deposit create a payment_credit with a value to set payment_credits.sum to zero' do
  #   FactoryBot.create(:payment_credit)
  #   FactoryBot.create(:payment_credit)
  #   get deposit_ops_admin_installment_path(@installment_1)
  #   assert_equal @seller.payment_credits.sum(:credit), 0
  # end
end
