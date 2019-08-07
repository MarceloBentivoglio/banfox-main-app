require "application_system_test_case"

class CheckingAccountTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  def create_seller_and_login
    @seller = FactoryBot.create(:seller, :can_operate)
    sign_in FactoryBot.create(:user, :auth_admin, seller: @seller)
  end

  test 'create a checking account' do
    create_seller_and_login
    visit ops_admin_seller_checking_accounts_path(@seller)
    click_link "new-checking-account"
    fill_in :checking_account_name, with: "Teste Capybara"
    fill_in :checking_account_document, with: "12345678901"
    fill_in :checking_account_account_number, with: "123123123123"
    fill_in :checking_account_branch, with: "Agência Capy"
    select "044", from: 'checking_account_bank_code'
    click_button :commit
    assert_selector "td", text: "Teste Capybara"
  end

  test 'update a checking account not changing bank_code' do
    create_seller_and_login
    checking_account = FactoryBot.create(:checking_account, seller: @seller)
    visit edit_ops_admin_seller_checking_account_path(@seller, checking_account)
    fill_in :checking_account_name, with: "New Capybara"
    click_button :commit
    assert_no_selector "td", text: "Teste Capybara"
    assert_selector "td", text: "New Capybara"
  end

  test 'update a checking account changing bank_code' do
    create_seller_and_login
    checking_account = FactoryBot.create(:checking_account, seller: @seller)
    visit edit_ops_admin_seller_checking_account_path(@seller, checking_account)
    select "M03", from: 'checking_account_bank_code'
    click_button :commit
    assert_no_selector "td", text: "044 - Banco BVA S.A."
    assert_selector "td", text: "M03 - Banco Fiat S.A."
  end

end
