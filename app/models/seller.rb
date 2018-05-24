class Seller < ApplicationRecord
  # We need to include this Model so that the custom validations AtLeatOne works
  include ActiveModel::Validations

  has_many :users
  has_many :invoices

# Through this constatants we are linking the name of the selllers table column
# with the name we want to appear in the view. It is used to facilitate the
# creation of the views

  PURPOSE = {
    "product_manufacture" => "Fabricação de Produtos",
    "service_provision" => "Prestação de Serviço",
    "product_reselling" => "Revenda de Produtos",
  }

  CLIENT_TYPES = {
    "company_clients" => "PF",
    "individual_clients" => "PJ",
    "government_clients" => "Governo",
  }

  PAYMENT_METHOD = {
    "generate_boleto" => "Emito Boleto",
    "generate_invoice" => "Emito Nota Fiscal",
    "receive_cheque" => "Recebo Cheques",
    "receive_money_transfer" => "Recebo TED/DOC",
  }

  PAYMENT_PERIOD = {
    "pay_up_front" => "A Vista",
    "pay_30_60_90" => "Parcelado em 30/60/90",
    "pay_90_plus" => "Parcelado em 90+",
  }

  CLIENT_OPTIONS = {
    "pay_factoring" => "Aceita pagar factoring",
    "permit_contact_client" => "Permito contactar meu cliente",
    "charge_payer" => "Quero que cobre meu cliente",
  }

  CONSENT = {
    "consent" => "Li e aceito os termos do site"
  }

  enum company_type: {
    LTDA: 0,
    SA: 1,
    ME: 2,
    MEI: 3,
  }

# If this enum is changed the steps in SellerStepsController must change as well
  enum validation_status: {
    basic: 0,
    company: 1,
    finantial: 2,
    client: 3,
    consent: 4,
    active: 5,
  }

  validates_with CnpjValidator, if: :active_or_basic?
  validates_with CpfValidator, if: :active_or_basic?
  validates :company_type, :full_name, :cpf, :company_name, :cnpj,  presence: true, if: :active_or_basic?
  validates :cpf, :cnpj,  uniqueness: true, if: :active_or_basic?
  validates_with AtLeastOneTrue, fields: [:product_manufacture, :service_provision, :product_reselling], if: :active_or_company?
  validates_with AtLeastOneTrue, fields: [:generate_boleto, :generate_invoice, :receive_cheque, :receive_money_transfer], if: :active_or_company?
  validates :revenue, numericality: { greater_than: 0 }, if: :active_or_finantial?
  validates :rental_cost, numericality: { greater_than: 0 }, if: :active_or_finantial?
  validates :employees, numericality: { greater_than: 0 }, if: :active_or_finantial?
  validates_with AtLeastOneTrue, fields: [:company_clients, :individual_clients, :government_clients], if: :active_or_client?
  validates_with AtLeastOneTrue, fields: [:pay_up_front, :pay_30_60_90, :pay_90_plus], if: :active_or_client?
  validates_with AtLeastOneTrue, fields: [:pay_factoring, :permit_contact_client, :charge_payer], if: :active_or_client?
  validates :consent, acceptance: true, if: :active_or_consent?

  # We need this to insert in the database a standardized CPF and CNPJ, that is,
  # without dots and slashes
  before_update :strip_cnpj, if: :cnpj_changed?
  before_update :strip_cpf, if: :cpf_changed?
  before_create :strip_cnpj
  before_create :strip_cpf


  # These methods are needed so that the validations works at each step of the
  # wizard. For more details:
  # https://github.com/schneems/wicked/wiki/Building-Partial-Objects-Step-by-Step

  def active_or_basic?
    basic? || active?
  end

  def active_or_company?
    company? || active?
  end

  def active_or_finantial?
    finantial? || active?
  end

  def active_or_client?
    client? || active?
  end

  def active_or_consent?
    consent? || active?
  end

  # We created this method to make the user come back to the next step when s/he
  # exit the wizard and then come back
  def next_step
    Seller.validation_statuses.key(Seller.validation_statuses[validation_status] + 1)
  end

  private

  def strip_cnpj
    self.cnpj = CNPJ::Formatter.strip(self.cnpj, strict: true)
  end

  def strip_cpf
    self.cpf = CPF::Formatter.strip(self.cpf, strict: true)
  end

end
