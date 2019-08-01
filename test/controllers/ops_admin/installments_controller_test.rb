require 'test_helper'

class OpsAdmin::InstallmentControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    using_shared_operation
    sign_in FactoryBot.create(:user, :auth_admin, seller: @seller)
  end

  test '.report_paid send a "payment received" mail to seller' do
    assert_difference 'ActionMailer::Base.deliveries.count', +1 do
      get report_paid_ops_admin_installment_path(@installment_1)
    end
    assert_equal "Sua parcela foi liquidada!", ActionMailer::Base.deliveries.last.subject
  end

  test '.report_paid send a "payment received with no protection left" mail to seller' do
    assert_difference 'ActionMailer::Base.deliveries.count', +1 do
      get report_paid_ops_admin_installment_path(@installment_1)
    end
  end

  test '.report_paid send a "overdued payment received" mail to seller' do
    assert_difference 'ActionMailer::Base.deliveries.count', +1 do
      get report_paid_ops_admin_installment_path(@installment_1)
    end
    assert_equal "Sua parcela foi liquidada!", ActionMailer::Base.deliveries.last.subject
  end

  test '.report_paid send a "overdued payment received with no protection left" mail to seller' do
    assert_difference 'ActionMailer::Base.deliveries.count', +1 do
      get report_paid_ops_admin_installment_path(@installment_1)
    end
  end

end
