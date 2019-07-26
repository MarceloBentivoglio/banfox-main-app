require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  def mock_seller(validation_status)
    seller = FactoryBot.create(:seller, 
                                  {
                                    full_name: "Capybara Bancapy", 
                                    cpf: "82155353995", 
                                    birth_date: "10-09-1990", 
                                    mobile: "11998765432", 
                                    validation_status: validation_status
                                  }
                               )
    seller
  end

  def commit_and_assert_step(step_number)
    click_button :commit
    assert_selector "span.point.active", text: step_number
  end

  test "create an user" do
    visit new_user_registration_path

    fill_in :user_email, with: "capybara@banfox.com.br"
    fill_in :user_password, with: "123123"

    commit_and_assert_step(1)
  end

  test 'create a seller' do
    # /seller_steps/basic
    sign_in FactoryBot.create(:user, seller: nil)

    visit seller_steps_path + "/basic"

    fill_in :seller_full_name, with: "Capybara Bancapy"
    fill_in :seller_cpf, with: "821.553.539-95"
    fill_in :seller_birth_date, with: "10/09/1990"
    fill_in :seller_mobile, with: "(11)998765432"

    commit_and_assert_step(2)
  end

  test 'create company' do
    seller = mock_seller(0)
    sign_in FactoryBot.create(:user, seller: seller)

    visit seller_steps_path + "/company"

    fill_in :seller_company_name, with: "Organizações Capybara"
    fill_in :seller_cnpj, with: "59.694.458/0001-30"
    fill_in :seller_website, with: "www.capybara.co"
    fill_in :seller_phone, with: "(11) 45671234"
    fill_in :zipcode, with: "08760-000"
    fill_in :seller_address_number, with: "11"

    commit_and_assert_step(3)
  end

  test 'update seller with finatials informations' do
    seller = mock_seller(1)
    sign_in FactoryBot.create(:user, seller: seller)

    visit seller_steps_path + "/finantial"

    fill_in :monthly_revenue, with: "100.000,00"
    fill_in :monthly_fixed_cost, with: "10,00"
    fill_in :monthly_units_sold, with: "1000"
    fill_in :cost_per_unit, with: "0,10"
    fill_in :debt, with: "0,00"

    commit_and_assert_step(4)
  end

  test 'conrfirm as partner' do
    seller = mock_seller(2)
    sign_in FactoryBot.create(:user, seller: seller)

    visit seller_steps_path + "/partner"

    click_link :'btn-option-yes'

    commit_and_assert_step(5)
  end

  test 'create partner' do
    seller = mock_seller(2)
    sign_in FactoryBot.create(:user, seller: seller)

    visit seller_steps_path + "/partner"

    click_link :'btn-option-no'
    fill_in :seller_full_name_partner, with: "Capybara Bancapy"
    fill_in :seller_cpf_partner, with: "821.553.539-95"
    fill_in :seller_birth_date_partner, with: "10/09/1990"
    fill_in :seller_mobile_partner, with: "(11)998765432"
    fill_in :seller_email_partner, with: "tatu@bantatu.com.br"

    commit_and_assert_step(5)
  end

  test 'confirm terms of service to conclude the process as pre-approved' do
    seller = mock_seller(3)
    mocked_cpf_check = mock()
    mocked_cpf_check.stubs(:analyze).returns(true)
    mocked_slack = mock()
    mocked_slack.stubs(:send_now).returns(true)
    CpfCheckRF.stubs(:new).with(seller).returns(mocked_cpf_check)
    SlackMessage.stubs(:new).returns(mocked_slack)
    sign_in FactoryBot.create(:user, seller: seller)

    visit seller_steps_path + "/consent"
    find('label', :text => 'Li e aceito os termos do site').click

    click_button :commit
    assert_selector "h4", text: "Bem vindo à Banfox!"
  end

  test 'confirm terms of service to conclude the process as rejected' do
    seller = mock_seller(3)
    mocked_cpf_check = mock()
    mocked_cpf_check.stubs(:analyze).returns(false)
    mocked_slack = mock()
    mocked_slack.stubs(:send_now).returns(true)
    CpfCheckRF.stubs(:new).with(seller).returns(mocked_cpf_check)
    SlackMessage.stubs(:new).returns(mocked_slack)
    #SellersController.any_instance.stubs(:check_revenue).returns(false)
    sign_in FactoryBot.create(:user, seller: seller)

    visit seller_steps_path + "/consent"
    find('label', :text => 'Li e aceito os termos do site').click

    click_button :commit
    assert_selector "h4", text: "Ainda não conseguimos te ajudar"
  end
end
