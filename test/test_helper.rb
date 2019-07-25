require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'
require 'capybara/minitest'

class ActiveSupport::TestCase
  include ActionDispatch::TestProcess
  include Warden::Test::Helpers

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

  Warden.test_mode!
end

Capybara.register_driver :headless_chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    'chromeOptions' => { args: %w(headless disable-gpu) + [ 'window-size=1280,800' ] })
  Capybara::Selenium::Driver.new app, browser: :chrome, desired_capabilities: capabilities
end
Capybara.save_path = Rails.root.join('tmp/capybara')
Capybara.javascript_driver = :headless_chrome

require 'mocha/minitest'
