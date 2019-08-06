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

  test 'sign an approved operation' do
    using_shared_operation
    ignore_slack_call
    @operation.installments.each do |installment|
      installment.approved!
    end
    mocked_doc_info = {"signer_signature_keys"=>
                        [
                          {"email"=>"joaquim@banfox.com.br", "signature_key"=>"c1bfec78-fdf4-4e13-8793-a89c24ed9d01"},
                          {"email"=>"joaquim.oliveira.nt@gmail.com", "signature_key"=>"edc94fa1-964c-4341-9e30-bb854dba47a1"},
                          {"email"=>"joao@banfox.com.br", "signature_key"=>"17f110da-2491-402a-bbd3-7ddc3bbd9b7d"}
                        ]
                      }
    mocked_doc_key = "198900ef-021f-4371-8373-ac3699f3667d"
    mocked_document = mock()
    mocked_document.expects(:sign_document_info).returns(mocked_doc_info)
    mocked_document.expects(:sign_document_key).returns(mocked_doc_key)
    SignDocuments.stubs(:new).returns(mocked_document)
    sign_in FactoryBot.create(:user, seller: @seller)
    visit store_installments_path
    find('a#create-document-button', :text => 'Vizualizar e assinar contrato').click
    assert_selector "span.section-title", text: "Contrato da operação"
    assert_selector "a#opened-installments-button", text: "Ver status da minha operação"
  end

  test 'cancel an operation in analysis' do
    using_shared_operation
    ignore_slack_call
    sign_in FactoryBot.create(:user, seller: @seller)
    visit store_installments_path
    accept_confirm do
      find('a#cancel-operation-button', :text => 'Cancelar Operação').click
    end
    assert_selector "input#create-operation-button"
  end

  test 'cancel an approved operation' do
    using_shared_operation
    ignore_slack_call
    @operation.installments.each do |installment|
      installment.approved!
    end
    sign_in FactoryBot.create(:user, seller: @seller)
    visit store_installments_path
    accept_confirm do
      find('a#cancel-operation-button', :text => 'Cancelar Operação').click
    end
    assert_selector "input#create-operation-button"
  end

  test 'cancel a partially_approved operation' do
    using_shared_operation
    ignore_slack_call
    @operation.installments.each do |installment|
      installment.approved!
    end
    @operation.installments.first.rejected!
    @operation.installments.first.payer_low_rated!

    sign_in FactoryBot.create(:user, seller: @seller)
    visit store_installments_path
    accept_confirm do
      find('a#cancel-operation-button', :text => 'Cancelar Operação').click
    end
    assert_selector "input#create-operation-button"
  end
end
