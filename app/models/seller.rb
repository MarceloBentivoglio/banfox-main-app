class Seller < ApplicationRecord
  monetize :monthly_revenue_cents, with_model_currency: :currency
  monetize :monthly_fixed_cost_cents, with_model_currency: :currency
  monetize :cost_per_unit_cents, with_model_currency: :currency
  monetize :debt_cents, with_model_currency: :currency
  monetize :operation_limit_cents, with_model_currency: :currency
  has_many :users, dependent: :destroy
  has_many :invoices, dependent: :destroy
  has_many :joint_debtors, dependent: :destroy
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
  include UserInputProcessing

  after_save :async_update_spreadsheet
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

  # For more information on company types: http://www.sebrae.com.br/sites/PortalSebrae/ufs/sp/conteudo_uf/quais-sao-os-tipos-de-empresas,af3db28a582a0610VgnVCM1000004c00210aRCRD
  enum company_type: {
    company_type_not_set: 0,
    ei:                   1,
    eireli:               2,
    me:                   3,
    mei:                  4,
    epp:                  5,
    ltda:                 6,
    sa:                   7,
    ss:                   8,
  }

# If this enum is changed the steps in SellerStepsController must change as well
  enum validation_status: {
    basic:     0,
    company:   1,
    finantial: 2,
    partner:   3,
    consent:   4,
    active:    5,
  }

  # If this enum is changed the steps in SellerStepsController must change as well
  enum analysis_status: {
    on_going:     0,
    rejected:     1,
    pre_approved: 2,
    approved:     3,
  }

  enum rejection_motive: {
    rejection_motive_not_set:        0,
    rejection_motive_non_applicable: 1,
    insuficient_revenue:             2,
    no_match_w_rf:                   3,
    rejected_on_commitee:            4,
  }

  enum tax_regime: {
    tax_regime_not_set: 0,
    simples:            1,
    presumido:          2,
    real:               3,
    real_ou_presumido:  4,
  }

  #TODO: make validations on the backend of phone number, cep, date of birth, because currently we are using validation only in the frontend (mask)
  validates_with CpfValidator, attr: :cpf, if: :active_or_basic?
  validates :cpf, uniqueness: { message: "já cadastrado, favor entrar em contato conosco" }, if: :active_or_basic?
  validates :mobile, format: { with: /\A[1-9]{2}9\d{8}\z/, message: "precisa ser um número de celular válido" }, if: :active_or_basic?
  validates_with DateValidator, attr: :birth_date, if: :active_or_basic?
  validates :full_name, :cpf, :mobile, :birth_date, presence: { message: "precisa ser informado" }, if: :active_or_basic?
  validates_with CnpjValidator, if: :active_or_company?
  validates :cnpj,  uniqueness: { message: "já cadastrado, favor entrar em contato conosco" }, if: :active_or_company?
  validates :phone, format: { with: /\A([1-9]{2}9\d{8}|^[1-9]{2}[2-5]\d{7})\z/, message: "precisa ser um número de linha fixa ou movel válido" }, if: :active_or_company?
  validates :company_name, :cnpj, :website, :phone,  :zip_code, :address, :neighborhood, :address_number, :city, :state, presence: { message: "precisa ser informado" }, if: :active_or_company?
  validates :monthly_revenue, :monthly_fixed_cost, :monthly_units_sold, :cost_per_unit, :debt, presence: { message: "precisa ser informado" }, if: :active_or_finantial?
  validates :monthly_revenue, :monthly_fixed_cost, :monthly_units_sold, :cost_per_unit, numericality: { greater_than: 0, message: "precisa ser maior que zero" }, if: :active_or_finantial?
  validates :monthly_units_sold, numericality: { only_integer: true, message: "precisa ser um número inteiro" }, if: :active_or_finantial?
  validates_with CpfValidator, attr: :cpf_partner, if: :active_or_partner?
  validates :cpf_partner, uniqueness: { message: "já cadastrado, favor entrar em contato conosco" }, if: :active_or_partner?
  validates :mobile_partner, format: { with: /\A[1-9]{2}9\d{8}\z/, message: "precisa ser um número de celular válido" }, if: :active_or_partner?
  validates_with DateValidator, attr: :birth_date_partner, if: :active_or_partner?
  validates :email_partner, email: true, if: :active_or_partner?
  validates :email_partner, corporate_email: true, if: :active_or_partner?
  validates :full_name_partner, :cpf_partner, :mobile_partner, :birth_date_partner, :email_partner, presence: { message: "precisa ser informado" }, if: :active_or_partner?
  validates :consent, acceptance: {message: "é preciso ler e aceitar os termos"}, if: :active_or_consent?
  validates :fator, numericality: {greater_than_or_equal_to: 0.01, less_than_or_equal_to: 0.07, allow_nil: true}
  validates :advalorem, numericality: {greater_than_or_equal_to: 0.001, less_than_or_equal_to: 0.01, allow_nil: true}
  validates :protection, numericality: {greater_than_or_equal_to: 0.05, less_than_or_equal_to: 0.3, allow_nil: true}

  # TODO: Refactor this block of code
  before_validation :clean_inputs, :downcase_words
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

  def active_or_partner?
    partner? || active?
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
      rf_full_name: self.rf_full_name,
      rf_sit_cad: self.rf_sit_cad,
      birth_date: self.birth_date,
      email: self.try(:users).try(:first).try(:email),
      mobile: self.mobile,
      company_name: self.company_name,
      company_nickname: self.company_nickname,
      cnpj: self.cnpj,
      phone: self.phone,
      website: self.website,
      company_type: self.company_type,
      inscr_est: self.inscr_est,
      inscr_mun: self.inscr_mun,
      nire: self.nire,
      address: self.address,
      address_number: self.address_number,
      address_comp: self.address_comp,
      neighborhood: self.neighborhood,
      city: self.city,
      state: self.state,
      zip_code: self.zip_code,
      monthly_revenue_cents: self.monthly_revenue_cents,
      monthly_fixed_cost_cents: self.monthly_fixed_cost_cents,
      monthly_units_sold: self.monthly_units_sold,
      cost_per_unit_cents: self.cost_per_unit_cents,
      debt_cents: self.debt_cents,
      operation_limit_cents: self.operation_limit_cents,
      protection: self.protection,
      fator: self.fator,
      advalorem: self.advalorem,
      full_name_partner: self.full_name_partner,
      cpf_partner: self.cpf_partner,
      rf_full_name_partner: self.rf_full_name_partner,
      rf_sit_cad_partner: self.rf_sit_cad_partner,
      birth_date_partner: self.birth_date_partner,
      mobile_partner: self.mobile_partner,
      email_partner: self.email_partner,
      consent: self.consent,
      validation_status: self.validation_status,
      visited: self.visited,
      analysis_status: self.analysis_status,
      rejection_motive: self.rejection_motive,
      social_contracts: get_documents_link(self.social_contracts),
      update_on_social_contracts: get_documents_link(self.update_on_social_contracts),
      address_proofs: get_documents_link(self.address_proofs),
      irpjs: get_documents_link(self.irpjs),
      revenue_proofs: get_documents_link(self.revenue_proofs),
      financial_statements: get_documents_link(self.financial_statements),
      cash_flows: get_documents_link(self.cash_flows),
      abc_clients: get_documents_link(self.abc_clients),
      sisbacens: get_documents_link(self.sisbacens),
      partners_cpfs: get_documents_link(self.partners_cpfs),
      partners_rgs: get_documents_link(self.partners_rgs),
      partners_irpfs: get_documents_link(self.partners_irpfs),
      partners_address_proofs: get_documents_link(self.partners_address_proofs),
    }.stringify_keys
  end

  def attachments
    {
      "Contrato social" => social_contracts,
      "Última alteração contratual" => update_on_social_contracts,
      "Comprovante de endereço da empresa" => address_proofs,
      "IRPJ (não enviar o recibo)" => irpjs,
      "Relação de faturamento dos últimos 12 meses (assinado por contador)" => revenue_proofs,
      "Balanço dos últimos dois exercícios" => financial_statements,
      "Extrato bancário dos últimos três meses" => cash_flows,
      "Curva ABC de clientes (utilizar planilha modelo abaixo)" => abc_clients,
      "Endividamento total por instituição financeira (utilizar planilha modelo abaixo)" => sisbacens,
      "CPF dos sócios" => partners_cpfs,
      "RG dos sócios" => partners_rgs,
      "IRPF dos sócios (não enviar o recibo)" => partners_irpfs,
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

  # TODO: rever esse método
  def used_limit
    Installment.total(:used_limit, self)
  end

  def available_limit
    operation_limit - used_limit
  end

  def set_pre_approved_initial_standard_settings
    self.fator = 0.039
    self.advalorem = 0.001
    self.protection = 0.2
    self.operation_limit = Money.new("2000000")
    self.save!
  end

  def fee
    fator + advalorem
  end


  private

  def async_update_spreadsheet
    SpreadsheetsRowSetterJob.perform_later(spreadsheet_id, worksheet_name, (self.id + 1), self.seller_attributes)
  end

  def spreadsheet_id
    Rails.application.credentials[Rails.env.to_sym][:google_spreadsheet_id]
  end

  def worksheet_name
    Rails.application.credentials[:google][:google_seller_worksheet_name]
  end

  def get_documents_link(attachments)
    links = []
    attachments.each do |attachment|
      links << Rails.application.routes.url_helpers.rails_blob_url(attachment)
    end
    links.join("\n")
  end

end
