euentrego = Seller.find_by_company_nickname("eu entrego")

cbd00 = Payer.create!(
  company_name: "companhia brasileira de distribuição",
  cnpj:"47508411234300",
  fator: euentrego.fator,
  advalorem: euentrego.advalorem,
  address: "av marginal direita do tiete",
  address_number: "342",
  neighborhood: "vila jaguara",
  zip_code: "05118100",
  inscr_mun: "52148173",
  city: "são paulo",
  state: "sp",
)

i4127 = Invoice.create!(
  invoice_type: "service",
  number: "4127",
  seller: euentrego,
  payer: cbd00,
  issue_date: Time.new(2019,4,25)
)

Installment.create!(
 invoice: i4127,
 operation: nil,
 number: "01",
 due_date: Time.new(2019,6,5),
 ordered_at: nil,
 deposited_at: nil,
 received_at: nil,
 backoffice_status: "available",
 liquidation_status: "liquidation_status_not_set",
 value: Money.new(5559850),
 final_net_value: nil,
 final_fator: nil,
 final_advalorem: nil,
 final_protection: nil,
 unavailability: "unavailability_non_applicable",
 rejection_motive: "rejection_motive_non_applicable",
)

# -------------------

cbd57 = Payer.create!(
  company_name: "companhia brasileira de distribuição",
  cnpj:"47508411096757",
  fator: euentrego.fator,
  advalorem: euentrego.advalorem,
  address: "rua professor serafim orlandi",
  address_number: "299",
  neighborhood: "vila mariana",
  zip_code: "04115090",
  inscr_mun: "27732916",
  city: "são paulo",
  state: "sp",
)

i4128 = Invoice.create!(
  invoice_type: "service",
  number: "4128",
  seller: euentrego,
  payer: cbd57,
  issue_date: Time.new(2019,4,25)
)

Installment.create!(
 invoice: i4128,
 operation: nil,
 number: "01",
 due_date: Time.new(2019,6,5),
 ordered_at: nil,
 deposited_at: nil,
 received_at: nil,
 backoffice_status: "available",
 liquidation_status: "liquidation_status_not_set",
 value: Money.new(1147600),
 final_net_value: nil,
 final_fator: nil,
 final_advalorem: nil,
 final_protection: nil,
 unavailability: "unavailability_non_applicable",
 rejection_motive: "rejection_motive_non_applicable",
)

# -------------------

cbd37 = Payer.create!(
  company_name: "companhia brasileira de distribuição",
  cnpj:"47508411000237",
  fator: euentrego.fator,
  advalorem: euentrego.advalorem,
  address: "av brigadeiro luis antonio",
  address_number: "3126",
  neighborhood: "jardim paulista",
  zip_code: "01402000",
  inscr_mun: "10144528",
  city: "são paulo",
  state: "sp",
)

i4129 = Invoice.create!(
  invoice_type: "service",
  number: "4129",
  seller: euentrego,
  payer: cbd37,
  issue_date: Time.new(2019,4,25)
)

Installment.create!(
 invoice: i4129,
 operation: nil,
 number: "01",
 due_date: Time.new(2019,6,5),
 ordered_at: nil,
 deposited_at: nil,
 received_at: nil,
 backoffice_status: "available",
 liquidation_status: "liquidation_status_not_set",
 value: Money.new(595900),
 final_net_value: nil,
 final_fator: nil,
 final_advalorem: nil,
 final_protection: nil,
 unavailability: "unavailability_non_applicable",
 rejection_motive: "rejection_motive_non_applicable",
)

# ------------------------

cbd06 = Payer.create!(
  company_name: "companhia brasileira de distribuição",
  cnpj:"47508411024906",
  fator: euentrego.fator,
  advalorem: euentrego.advalorem,
  address: "rua martin afonso",
  address_number: "2162",
  neighborhood: "champagnat",
  zip_code: "80730030",
  inscr_mun: "",
  city: "curitiba",
  state: "pr",
)

i4130 = Invoice.create!(
  invoice_type: "service",
  number: "4130",
  seller: euentrego,
  payer: cbd06,
  issue_date: Time.new(2019,4,25)
)

Installment.create!(
 invoice: i4130,
 operation: nil,
 number: "01",
 due_date: Time.new(2019,6,5),
 ordered_at: nil,
 deposited_at: nil,
 received_at: nil,
 backoffice_status: "available",
 liquidation_status: "liquidation_status_not_set",
 value: Money.new(344500),
 final_net_value: nil,
 final_fator: nil,
 final_advalorem: nil,
 final_protection: nil,
 unavailability: "unavailability_non_applicable",
 rejection_motive: "rejection_motive_non_applicable",
)

# ------------------------

cbd71 = Payer.create!(
  company_name: "companhia brasileira de distribuição",
  cnpj:"47508411208571",
  fator: euentrego.fator,
  advalorem: euentrego.advalorem,
  address: "avenida major sylvio de magalhães padilha",
  address_number: "16741",
  neighborhood: "jardim morumbi",
  zip_code: "05693000",
  inscr_mun: "51187361",
  city: "são paulo",
  state: "sp",
)

i4131 = Invoice.create!(
  invoice_type: "service",
  number: "4131",
  seller: euentrego,
  payer: cbd71,
  issue_date: Time.new(2019,4,25)
)

Installment.create!(
 invoice: i4131,
 operation: nil,
 number: "01",
 due_date: Time.new(2019,6,5),
 ordered_at: nil,
 deposited_at: nil,
 received_at: nil,
 backoffice_status: "available",
 liquidation_status: "liquidation_status_not_set",
 value: Money.new(334700),
 final_net_value: nil,
 final_fator: nil,
 final_advalorem: nil,
 final_protection: nil,
 unavailability: "unavailability_non_applicable",
 rejection_motive: "rejection_motive_non_applicable",
)

# ------------------------

cbd21 = Payer.create!(
  company_name: "companhia brasileira de distribuição",
  cnpj:"47508411254921",
  fator: euentrego.fator,
  advalorem: euentrego.advalorem,
  address: "rua jose linhares",
  address_number: "",
  neighborhood: "leblon",
  zip_code: "22430220",
  inscr_mun: "",
  city: "rio de janeiro",
  state: "rj",
)

i4132 = Invoice.create!(
  invoice_type: "service",
  number: "4132",
  seller: euentrego,
  payer: cbd21,
  issue_date: Time.new(2019,4,25)
)

Installment.create!(
 invoice: i4132,
 operation: nil,
 number: "01",
 due_date: Time.new(2019,6,5),
 ordered_at: nil,
 deposited_at: nil,
 received_at: nil,
 backoffice_status: "available",
 liquidation_status: "liquidation_status_not_set",
 value: Money.new(302400),
 final_net_value: nil,
 final_fator: nil,
 final_advalorem: nil,
 final_protection: nil,
 unavailability: "unavailability_non_applicable",
 rejection_motive: "rejection_motive_non_applicable",
)
