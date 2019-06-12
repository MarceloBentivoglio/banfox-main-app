puts "Creating Fluidtec..........."

fluidtec = Seller.create!(
  full_name: "antonio bena da silva",
  cpf: "14369680387",
  rf_full_name: "antonio bena da silva",
  rf_sit_cad: "regular",
  birth_date: "12111956",
  mobile: "11963235090",
  company_name: "fluidtec sistemas de automação eireli",
  company_nickname: "fluidtec",
  cnpj: "15028515000177",
  phone: "1134555080",
  website: "www.fluidtec.com.br",
  address: "alameda rio negro",
  address_number: "1030",
  address_comp: "escritorio 206",
  neighborhood: "alphaville centro industrial e empresarial/alphavi...",
  state: "sp",
  city: "barueri",
  zip_code: "06454000",
  inscr_est: "",
  inscr_mun: "",
  nire: "",
  company_type: "eireli",
  operation_limit_cents: 30000000,
  operation_limit_currency: "BRL",
  fator: 0.039,
  advalorem: 0.001,
  protection: 0.2,
  monthly_revenue_cents: 50000000,
  monthly_revenue_currency: "BRL",
  monthly_fixed_cost_cents: 35000000,
  monthly_fixed_cost_currency: "BRL",
  monthly_units_sold: 10500,
  cost_per_unit_cents: 3300,
  cost_per_unit_currency: "BRL",
  debt_cents: 3800000,
  debt_currency: "BRL",
  full_name_partner: "antonio bena da silva",
  cpf_partner: "14369680387",
  rf_full_name_partner: "antonio bena da silva",
  rf_sit_cad_partner: "regular",
  birth_date_partner: "12111956",
  mobile_partner: "11953786611",
  email_partner: "bena.silva@fluidtec.com.br",
  consent: true,
  validation_status: "active",
  visited: true,
  analysis_status: "approved",
  rejection_motive: "rejection_motive_non_applicable",
)

fluidtec_user = User.create!(
  email: "bena.silva@fluidtec.com.br",
  password: "fluidtec",
  admin: false,
  seller: fluidtec
)

gme = Payer.create!(
    company_name: "gme aerospace industria de material composto s.a",
    cnpj:"09138393000179",
    fator: fluidtec.fator,
    advalorem: fluidtec.advalorem,
)

tunkers = Payer.create!(
    company_name: "tunkers do brasil ltda",
    cnpj:"02619891000194",
    fator: fluidtec.fator,
    advalorem: fluidtec.advalorem,
)

abb = Payer.create!(
    company_name: "abb ltda",
    cnpj:"61074829001103",
    fator: fluidtec.fator,
    advalorem: fluidtec.advalorem,
)

motoman = Payer.create!(
    company_name: "motoman robotica do brasil ltda",
    cnpj:"08515495000101",
    fator: fluidtec.fator,
    advalorem: fluidtec.advalorem,
)

comau = Payer.create!(
    company_name: "comau do brasil industria e comercio ltda",
    cnpj:"02693750000111",
    fator: fluidtec.fator,
    advalorem: fluidtec.advalorem,
)

comau56 = Payer.create!(
    company_name: "comau do brasil industria e comercio ltda",
    cnpj:"02693750003056",
    fator: fluidtec.fator,
    advalorem: fluidtec.advalorem,
)

operation781 = Operation.create!(
  consent: true,
  signed: true,
)
operation821 = Operation.create!(
  consent: true,
  signed: true,
)
operation823 = Operation.create!(
  consent: true,
  signed: true,
)
operation831 = Operation.create!(
  consent: true,
  signed: true,

)
operation844 = Operation.create!(
  consent: true,
  signed: true,
)
operation848 = Operation.create!(
  consent: true,
  signed: true,
)
operation850 = Operation.create!(
  consent: true,
  signed: true,
)

puts "Operation 781 ........"

i1 = Invoice.create!(
  invoice_type: "service",
  number: "245",
  seller: fluidtec,
  payer: gme,
)

Installment.create!(
 invoice: i1,
 operation: operation781,
 number: "01",
 due_date: Time.new(2019,2,26),
 ordered_at: Time.new(2019,2,6,9),
 deposited_at: Time.new(2019,2,6,11),
 received_at: Time.new(2019,3,15,11),
 backoffice_status: "deposited",
 liquidation_status: "paid",
 value: Money.new(4878900),
 initial_net_value: Money.new(4707414),
 initial_fator: Money.new(226361),
 initial_advalorem: Money.new(5802),
 initial_protection: Money.new(926219),
 unavailability: "unavailability_non_applicable",
 rejection_motive: "rejection_motive_non_applicable",
)

i2 = Invoice.create!(
  invoice_type: "service",
  number: "244",
  seller: fluidtec,
  payer: gme,
)

Installment.create!(
 invoice: i2,
 operation: operation781,
 number: "01",
 due_date: Time.new(2019,2,26),
 ordered_at: Time.new(2019,2,6,9),
 deposited_at: Time.new(2019,2,6,11),
 received_at: Time.new(2019,3,15,11),
 backoffice_status: "deposited",
 liquidation_status: "paid",
 value: Money.new(2464800),
 initial_net_value: Money.new(2378166),
 initial_fator: Money.new(114355),
 initial_advalorem: Money.new(2948),
 initial_protection: Money.new(486475),
 unavailability: "unavailability_non_applicable",
 rejection_motive: "rejection_motive_non_applicable",
)

puts "Operation 821 ........"

i1 = Invoice.create!(
  invoice_type: "service",
  number: "293",
  seller: fluidtec,
  payer: comau,
)

Installment.create!(
 invoice: i1,
 operation: operation821,
 number: "01",
 due_date: Time.new(2019,5,2),
 ordered_at: Time.new(2019,3,26,9),
 deposited_at: Time.new(2019,3,26,11),
 received_at: nil,
 backoffice_status: "deposited",
 liquidation_status: "opened",
 value: Money.new(4860000),
 initial_net_value: Money.new(4582143),
 initial_fator: Money.new(246524),
 initial_advalorem: Money.new(6804),
 initial_protection: Money.new(914478),
 unavailability: "unavailability_non_applicable",
 rejection_motive: "rejection_motive_non_applicable",
)

i2 = Invoice.create!(
  invoice_type: "service",
  number: "298",
  seller: fluidtec,
  payer: comau,
)

Installment.create!(
 invoice: i2,
 operation: operation821,
 number: "01",
 due_date: Time.new(2019,5,9),
 ordered_at: Time.new(2019,3,26,9),
 deposited_at: Time.new(2019,3,26,11),
 received_at: Time.new(2019,5,9,11),
 backoffice_status: "deposited",
 liquidation_status: "paid",
 value: Money.new(7315000),
 initial_net_value: Money.new(6833448),
 initial_fator: Money.new(431036),
 initial_advalorem: Money.new(11938),
 initial_protection: Money.new(1463000),
 unavailability: "unavailability_non_applicable",
 rejection_motive: "rejection_motive_non_applicable",
)

puts "Operation 823 ........"

i1 = Invoice.create!(
  invoice_type: "service",
  number: "299",
  seller: fluidtec,
  payer: comau56,
)

Installment.create!(
 invoice: i1,
 operation: operation823,
 number: "01",
 due_date: Time.new(2019,5,9),
 ordered_at: Time.new(2019,3,27,9),
 deposited_at: Time.new(2019,3,27,11),
 received_at: Time.new(2019,5,9,11),
 backoffice_status: "deposited",
 liquidation_status: "paid",
 value: Money.new(1887000),
 initial_net_value: Money.new(1760700),
 initial_fator: Money.new(113416),
 initial_advalorem: Money.new(3017),
 initial_protection: Money.new(377400),
 unavailability: "unavailability_non_applicable",
 rejection_motive: "rejection_motive_non_applicable",
)

i2 = Invoice.create!(
  invoice_type: "service",
  number: "296",
  seller: fluidtec,
  payer: motoman,
)

Installment.create!(
 invoice: i2,
 operation: operation823,
 number: "01",
 due_date: Time.new(2019,4,4),
 ordered_at: Time.new(2019,3,27,9),
 deposited_at: Time.new(2019,3,27,11),
 received_at: Time.new(2019,4,4,11),
 backoffice_status: "deposited",
 liquidation_status: "paid",
 value: Money.new(1312350),
 initial_net_value: Money.new(1284607),
 initial_fator: Money.new(21847),
 initial_advalorem: Money.new(570),
 initial_protection: Money.new(262470),
 unavailability: "unavailability_non_applicable",
 rejection_motive: "rejection_motive_non_applicable",
)

puts "Operation 831 ........"

i1 = Invoice.create!(
  invoice_type: "service",
  number: "306",
  seller: fluidtec,
  payer: motoman,
)

Installment.create!(
 invoice: i1,
 operation: operation831,
 number: "01",
 due_date: Time.new(2019,4,19),
 ordered_at: Time.new(2019,4,5,9),
 deposited_at: Time.new(2019,4,5,11),
 received_at: Time.new(2019,4,19,11),
 backoffice_status: "deposited",
 liquidation_status: "paid",
 value: Money.new(881400),
 initial_net_value: Money.new(854317),
 initial_fator: Money.new(23068),
 initial_advalorem: Money.new(588),
 initial_protection: Money.new(170864),
 unavailability: "unavailability_non_applicable",
 rejection_motive: "rejection_motive_non_applicable",
)

puts "Operation 844 ........"

i1 = Invoice.create!(
  invoice_type: "service",
  number: "323",
  seller: fluidtec,
  payer: abb,
)

Installment.create!(
 invoice: i1,
 operation: operation844,
 number: "01",
 due_date: Time.new(2019,5,24),
 ordered_at: Time.new(2019,4,24,9),
 deposited_at: Time.new(2019,4,24,11),
 received_at: nil,
 backoffice_status: "deposited",
 liquidation_status: "opened",
 value: Money.new(5460600),
 initial_net_value: Money.new(5175271),
 initial_fator: Money.new(247644),
 initial_advalorem: Money.new(6373),
 initial_protection: Money.new(1092120),
 unavailability: "unavailability_non_applicable",
 rejection_motive: "rejection_motive_non_applicable",
)

puts "Operation 848 ........"

i1 = Invoice.create!(
  invoice_type: "service",
  number: "328",
  seller: fluidtec,
  payer: tunkers,
)

Installment.create!(
 invoice: i1,
 operation: operation848,
 number: "01",
 due_date: Time.new(2019,5,29),
 ordered_at: Time.new(2019,4,29,9),
 deposited_at: Time.new(2019,4,29,11),
 received_at: nil,
 backoffice_status: "deposited",
 liquidation_status: "opened",
 value: Money.new(1226250),
 initial_net_value: Money.new(1158228),
 initial_fator: Money.new(55612),
 initial_advalorem: Money.new(1431),
 initial_protection: Money.new(245220),
 unavailability: "unavailability_non_applicable",
 rejection_motive: "rejection_motive_non_applicable",
)

puts "Operation 850 ........"

i1 = Invoice.create!(
  invoice_type: "service",
  number: "330",
  seller: fluidtec,
  payer: gme,
)

Installment.create!(
 invoice: i1,
 operation: operation850,
 number: "01",
 due_date: Time.new(2019,5,30),
 ordered_at: Time.new(2019,4,30,9),
 deposited_at: Time.new(2019,4,30,11),
 received_at: nil,
 backoffice_status: "deposited",
 liquidation_status: "opened",
 value: Money.new(2030000),
 initial_net_value: Money.new(1925820),
 initial_fator: Money.new(92063),
 initial_advalorem: Money.new(2369),
 initial_protection: Money.new(406000),
 unavailability: "unavailability_non_applicable",
 rejection_motive: "rejection_motive_non_applicable",
)

i2 = Invoice.create!(
  invoice_type: "service",
  number: "329",
  seller: fluidtec,
  payer: gme,
)

Installment.create!(
 invoice: i2,
 operation: operation850,
 number: "01",
 due_date: Time.new(2019,6,29),
 ordered_at: Time.new(2019,4,30,9),
 deposited_at: Time.new(2019,4,30,11),
 received_at: nil,
 backoffice_status: "deposited",
 liquidation_status: "opened",
 value: Money.new(2150000),
 initial_net_value: Money.new(1955448),
 initial_fator: Money.new(177549),
 initial_advalorem: Money.new(4655),
 initial_protection: Money.new(430000),
 unavailability: "unavailability_non_applicable",
 rejection_motive: "rejection_motive_non_applicable",
)

puts "Joint debtors ......"

joint_debtor = JointDebtor.create!(
  name: "Anderson Claudio Joaquim Cruzado",
  birthdate: Date.new(1980,06,26),
  mobile: "11963235090",
  documentation: "28556090893",
  email: "anderson.cruzado@fluidtec.com.br",
  seller: fluidtec,
)
