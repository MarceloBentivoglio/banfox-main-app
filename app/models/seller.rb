class Seller < ApplicationRecord
  # We need to include this Model so that the custom validations AtLeatOne works
  include ActiveModel::Validations

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
  validates :full_name, :cpf, :phone, :company_name, :cnpj,  presence: { message: "precisa ser informado" }, if: :active_or_basic?
  validates :cpf, :cnpj,  uniqueness: { message: "já cadastrado, favor entrar em contato conosco" }, if: :active_or_basic?
  validates :monthly_revenue, :monthly_fixed_cost, :monthly_units_sold, :cost_per_unit, :debt, numericality: { greater_than: 0, message: "precisa ser maior que zero" }, if: :active_or_finantial?
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
