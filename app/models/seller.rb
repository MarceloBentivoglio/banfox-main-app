class Seller < ApplicationRecord
  # We need to include this Model so that the custom validations AtLeatOne works
  include ActiveModel::Validations

  monetize :operation_limit_cents, with_model_currency: :currency
  has_many :users, dependent: :destroy
  has_many :invoices, dependent: :destroy
  has_many :finished_invoices, -> {finished}, class_name: "Invoice"
  has_many_attached :social_contracts, dependent: :purge
  has_many_attached :update_on_social_contracts, dependent: :purge
  has_many_attached :address_proofs, dependent: :purge
  has_many_attached :irpjs, dependent: :purge
  has_many_attached :revenue_proofs, dependent: :purge
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
    :sisbacens,
    :partners_cpfs,
    :partners_rgs,
    :partners_irpfs,
    :partners_address_proofs,
  ]

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
    "pay_up_front" => "À Vista",
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

  # If this enum is changed the steps in SellerStepsController must change as well
  enum analysis_status: {
    on_going: 0,
    rejected: 1,
    approved: 2,
  }

  validates_with CnpjValidator, if: :active_or_basic?
  validates_with CpfValidator, if: :active_or_basic?
  validates :company_type, :full_name, :cpf, :phone, :company_name, :cnpj,  presence: { message: "precisa ser informado" }, if: :active_or_basic?
  validates :cpf, :cnpj,  uniqueness: { message: "já cadastrado, favor entrar em contato conosco" }, if: :active_or_basic?
  # validates_with AtLeastOneTrue, fields: [:product_manufacture, :service_provision, :product_reselling], if: :active_or_company?
  # validates_with AtLeastOneTrue, fields: [:generate_boleto, :generate_invoice, :receive_cheque, :receive_money_transfer], if: :active_or_company?
  validates :revenue, numericality: { greater_than: 0, message: "precisa ser maior que zero" }, if: :active_or_finantial?
  validates :rental_cost, numericality: { greater_than: 0, message: "precisa ser maior que zero" }, if: :active_or_finantial?
  validates :employees, numericality: { greater_than: 0, message: "precisa ser maior que zero" }, if: :active_or_finantial?
  # validates_with AtLeastOneTrue, fields: [:company_clients, :individual_clients, :government_clients], if: :active_or_client?
  # validates_with AtLeastOneTrue, fields: [:pay_up_front, :pay_30_60_90, :pay_90_plus], if: :active_or_client?
  # validates_with AtLeastOneTrue, fields: [:pay_factoring, :permit_contact_client, :charge_payer], if: :active_or_client?
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

  def attachments
    {
      "Contrato social" => social_contracts,
      "Última alteração contratual" => update_on_social_contracts,
      "Comprovante de endereço da empresa" => address_proofs,
      "IRPJ" => irpjs,
      "Relação de faturamento dos últimos 12 meses (assinado por contador)" => revenue_proofs,
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

  # def seller_attributes
  #   {
  #     id: self.id,
  #     full_name: self.full_name,
  #     cpf: self.cpf,
  #     phone: self.phone,
  #     company_name: self.company_name,
  #     company_nickname: self.company_nickname,
  #     cnpj: self.cnpj,
  #     company_type: self.company_type,
  #     revenue: self.revenue,
  #     employees: self.employees,
  #     rental_cost: self.rental_cost,
  #     product_manufacture: self.product_manufacture,
  #     service_provision: self.service_provision,
  #     product_reselling: self.product_reselling,
  #     generate_boleto: self.generate_boleto,
  #     generate_invoice: self.generate_invoice,
  #     receive_cheque: self.receive_cheque,
  #     receive_money_transfer: self.receive_money_transfer,
  #     company_clients: self.company_clients,
  #     individual_clients: self.individual_clients,
  #     government_clients: self.government_clients,
  #     pay_up_front: self.pay_up_front,
  #     pay_30_60_90: self.pay_30_60_90,
  #     pay_90_plus: self.pay_90_plus,
  #     pay_factoring: self.pay_factoring,
  #     permit_contact_client: self.permit_contact_client,
  #     charge_payer: self.charge_payer,
  #     consent: self.consent,
  #     validation_status: self.validation_status,
  #     created_at: self.created_at,
  #     updated_at: self.updated_at,
  #     visited: self.visited,
  #     analysis_status: self.analysis_status,
  #     zip_code: self.zip_code,
  #     address: self.address,
  #     address_number: self.address_number,
  #     neighborhood: self.neighborhood,
  #     state: self.state,
  #     city: self.city,
  #     operation_limit_cents: self.operation_limit_cents,
  #     operation_limit_currency: self.operation_limit_currency,
  #   }

  # end

  private

  def strip_cnpj
    self.cnpj = CNPJ::Formatter.strip(self.cnpj, strict: true)
  end

  def strip_cpf
    self.cpf = CPF::Formatter.strip(self.cpf, strict: true)
  end

  # def correct_document_mime_type
  #   if proof_of_address.attached? && !proof_of_address.content_type.in?(%w(application/msword application/pdf))
  #     errors.add(:proof_of_address, 'Must be a PDF or a DOC file')
  #   end
  # end

end
