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
    InstallmentMailer.expects(:paid).with(@installment_1, @seller.users.first, @seller).returns(mail_test)
    assert_difference 'ActionMailer::Base.deliveries.count', +1 do
      get report_paid_ops_admin_installment_path(@installment_1)
    end
  end

  test '.report_paid send a "payment received with no protection left" mail to seller' do
    mail_test = setting_mail
    Installment.any_instance.stubs(:protection).returns(0)
    InstallmentMailer.expects(:paid_without_protection).with(@installment_1, @seller.users.first, @seller).returns(mail_test)
    assert_difference 'ActionMailer::Base.deliveries.count', +1 do
      get report_paid_ops_admin_installment_path(@installment_1)
    end
  end

  test '.report_paid send a "overdued payment received" mail to seller' do
    mail_test = setting_mail
    Installment.any_instance.stubs(:operation_ended_overdue?).returns(true)
    InstallmentMailer.expects(:paid_overdue).with(@installment_1, @seller.users.first, @seller).returns(mail_test)
    assert_difference 'ActionMailer::Base.deliveries.count', +1 do
      get report_paid_ops_admin_installment_path(@installment_1)
    end
  end

  test '.report_paid send a "overdued payment received with no protection left" mail to seller' do
    mail_test = setting_mail
    Installment.any_instance.stubs(:protection).returns(0)
    Installment.any_instance.stubs(:operation_ended_overdue?).returns(true)
    InstallmentMailer.expects(:paid_overdue_without_protection).with(@installment_1, @seller.users.first, @seller).returns(mail_test)
    assert_difference 'ActionMailer::Base.deliveries.count', +1 do
      get report_paid_ops_admin_installment_path(@installment_1)
    end
  end

end
