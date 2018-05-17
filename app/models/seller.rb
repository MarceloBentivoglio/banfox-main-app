class Seller < ApplicationRecord
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

  has_many :users
  has_many :invoices

end
