class Seller < ApplicationRecord
  after_save :async_update_spreadsheet

  monetize :monthly_revenue_cents, with_model_currency: :currency
  monetize :monthly_fixed_cost_cents, with_model_currency: :currency
  monetize :cost_per_unit_cents, with_model_currency: :currency
  monetize :debt_cents, with_model_currency: :currency
  monetize :operation_limit_cents, with_model_currency: :currency
  has_many :users, dependent: :destroy
  has_many :invoices, dependent: :destroy
  has_many :finished_invoices, -> {finished}, class_name: "Invoice"
  has_many_attached :social_contracts, dependent: :purge
  has_many_attached :update_on_social_contracts, dependent: :purge
  has_many_attached :address_proofs, dependent: :purge
  has_many_attached :irpjs, dependent: :purge
  has_many_attached :revenue_proofs, dependent: :purge
  has_many_attached :financial_statements, dependent: :purge
  has_many_attached :cash_flows, dependent: :purge
  has_many_attached :abc_clients, dependent: :purge
  has_many_attached :sisbacens, dependent: :purge
  has_many_attached :partners_cpfs, dependent: :purge
  has_many_attached :partners_rgs, dependent: :purge
  has_many_attached :partners_irpfs, dependent: :purge
  has_many_attached :partners_address_proofs, dependent: :purge

# validate :correct_document_mime_type

# Through this constatants we are linking the name of the selllers table column
# with the name we want to appear in the view. It is used to facilitate the
# creation of the views
  DOCUMENTS = [
    :social_contracts,
    :update_on_social_contracts,
    :address_proofs,
    :irpjs,
    :revenue_proofs,
    :financial_statements,
    :cash_flows,
    :abc_clients,
    :sisbacens,
    :partners_cpfs,
    :partners_rgs,
    :partners_irpfs,
    :partners_address_proofs,
  ].freeze

  CONSENT = {
    "consent" => "Li e aceito os termos do site"
  }.freeze

  enum company_type: {
    ltda: 0,
    sa: 1,
    me: 2,
    mei: 3,
    epp: 4,
  }

# If this enum is changed the steps in SellerStepsController must change as well
  enum validation_status: {
    basic: 0,
    finantial: 1,
    consent: 2,
    active: 3,
  }

  # If this enum is changed the steps in SellerStepsController must change as well
  enum analysis_status: {
    on_going: 0,
    rejected: 1,
    approved: 2,
  }

  validates_with CnpjValidator, if: :active_or_basic?
  validates_with CpfValidator, if: :active_or_basic?
  validates :full_name, :cpf, :phone, :company_name, :cnpj,  presence: { message: "precisa ser informado" }, if: :active_or_basic?
  validates :cpf, :cnpj,  uniqueness: { message: "já cadastrado, favor entrar em contato conosco" }, if: :active_or_basic?
  validates :monthly_revenue, :monthly_fixed_cost, :monthly_units_sold, :cost_per_unit, :debt, presence: { message: "precisa ser informado" }, if: :active_or_finantial?
  validates :monthly_revenue, :monthly_fixed_cost, :monthly_units_sold, :cost_per_unit, numericality: { greater_than: 0, message: "precisa ser maior que zero" }, if: :active_or_finantial?
  validates :consent, acceptance: {message: "é preciso ler e aceitar os termos"}, if: :active_or_consent?

  # We need this to insert in the database a standardized CPF and CNPJ, that is,
  # without dots and slashes

  before_validation :strip_cnpj
  before_validation :strip_cpf
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

  def active_or_finantial?
    finantial? || active?
  end

  def active_or_consent?
    consent? || active?
  end

  # We created this method to make the user come back to the next step when s/he
  # exit the wizard and then come back
  def next_step
    Seller.validation_statuses.key(Seller.validation_statuses[validation_status] + 1)
  end

  def seller_attributes
    {
      id: self.id,
      full_name: self.full_name,
      cpf: self.cpf,
      email: self.users.first.email,
      phone: self.phone,
      company_name: self.company_name,
      company_nickname: self.company_nickname,
      cnpj: self.cnpj,
      inscr_est: self.inscr_est,
      inscr_mun: self.inscr_mun,
      nire: self.nire,
      company_type: self.company_type,
      monthly_revenue_cents: self.monthly_revenue_cents,
      monthly_fixed_cost_cents: self.monthly_fixed_cost_cents,
      monthly_units_sold: self.monthly_units_sold,
      cost_per_unit_cents: self.cost_per_unit_cents,
      debt_cents: self.debt_cents,
      operation_limit_cents: self.operation_limit_cents,
      validation_status: self.validation_status,
      analysis_status: self.analysis_status,
      visited: self.visited,
      address: self.address,
      address_number: self.address_number,
      address_comp: self.address_comp,
      neighborhood: self.neighborhood,
      state: self.state,
      city: self.city,
      zip_code: self.zip_code,
      consent: self.consent,
    }.stringify_keys
  end

  def attachments
    {
      "Contrato social" => social_contracts,
      "Última alteração contratual" => update_on_social_contracts,
      "Comprovante de endereço da empresa" => address_proofs,
      "IRPJ" => irpjs,
      "Relação de faturamento dos últimos 12 meses (assinado por contador)" => revenue_proofs,
      "Balanço dos últimos dois exercícios" => financial_statements,
      "Extrato bancário dos últimos três meses (ou demonstrativos de resultados do últimos três exercícios)" => cash_flows,
      "Curva ABC de clientes (ou principais clientes que geram a maior parte da receita da sua companhia)" => abc_clients,
      "SISBACEN" => sisbacens,
      "CPF dos sócios" => partners_cpfs,
      "RG dos sócios" => partners_rgs,
      "IRPF dos sócios" => partners_irpfs,
      "Comprovante de endereço dos sócios" => partners_address_proofs,
    }
  end

  def documentation_completed?
    DOCUMENTS.all? do |document|
      self.__send__(document).attached?
    end
  end

  def categories_w_documents_num
    docs_uploaded = DOCUMENTS.map do |document|
      self.__send__(document).attached?
    end
    docs_uploaded.count(true)
  end

  def total_documents
    DOCUMENTS.length
  end

  def used_limit
    Invoice.total(:opened_all, self)
  end

  private

  def strip_cnpj
    self.cnpj = CNPJ::Formatter.strip(self.cnpj, strict: true)
  end

  def strip_cpf
    self.cpf = CPF::Formatter.strip(self.cpf, strict: true)
  end

  def async_update_spreadsheet
    SpreadsheetsRowSetterJob.perform_later(spreadsheet_id, worksheet_name, (self.id + 1), self.seller_attributes)
  end

  def spreadsheet_id
    Rails.application.credentials[Rails.env.to_sym][:google_spreadsheet_id]
  end

  def worksheet_name
    Rails.application.credentials[Rails.env.to_sym][:google_seller_worksheet_name]
  end

  # def correct_document_mime_type
  #   if proof_of_address.attached? && !proof_of_address.content_type.in?(%w(application/msword application/pdf))
  #     errors.add(:proof_of_address, 'Must be a PDF or a DOC file')
  #   end
  # end

end
