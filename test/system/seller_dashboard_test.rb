require "application_system_test_case"

class SellerDashboardTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  def seller_create_and_login
    seller = FactoryBot.create(:seller)
    sign_in FactoryBot.create(:user, seller: seller)
  end

  def visit_dashboard_and_upload_xml
    ignore_slack_call
    visit store_installments_path
    find('span', :text => 'Adicionar notas fiscais').click
    attach_file('invoices_documents_bundle[documents][]', "#{Rails.root}/test/fixtures/files/notaDeTeste.xml", visible: :all)
    click_button :commit, value: "Subir arquivos"
  end

  test 'send an operation to analysis' do
    seller_create_and_login
    visit_dashboard_and_upload_xml
    check 'operation_consent'
    click_button :commit, value: "Confirmar e Enviar para análise"
    assert_selector "span", text: "Você tem 1 operação em análise."
    assert_selector "a#cancel-operation-button", text: "Cancelar Operação"
  end

  test 'cancel an operation' do
    using_shared_operation
    ignore_slack_call
    sign_in FactoryBot.create(:user, seller: @seller)
    visit store_installments_path
    accept_confirm do
      find('a#cancel-operation-button', :text => 'Cancelar Operação').click
    end
    assert_selector "input#create-operation-button"
  end
end
