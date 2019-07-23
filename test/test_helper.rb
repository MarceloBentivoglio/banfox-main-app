require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  include ActionDispatch::TestProcess

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #fixtures :all

  def using_shared_operation
    @operation = FactoryBot.create(:operation)

    @seller = FactoryBot.create(:seller)

    @payer_1 = FactoryBot.create(:payer)
    @payer_2 = FactoryBot.create(:payer, cnpj: '000000000')

    @invoice_1 = FactoryBot.create(
      :invoice,
      payer: @payer_1,
      seller: @seller
    )
    @invoice_2 = FactoryBot.create(
      :invoice,
      payer: @payer_2,
      seller: @seller
    )

    @installment_1 = FactoryBot.create(:installment, invoice: @invoice_1)
    @installment_2 = FactoryBot.create(:installment, invoice: @invoice_1)
    @installment_3 = FactoryBot.create(:installment, invoice: @invoice_2)

    #Settings up different installments for different invoices
    @installment_1.update(operation_id: @operation.id)
    @installment_2.update(operation_id: @operation.id)
    @installment_3.update(operation_id: @operation.id)

    @operation
  end
end
require 'mocha/minitest'
