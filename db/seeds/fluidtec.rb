puts "Starting seed with real client data............"
puts "Creating doc parser user......."

user1 = User.create!(
  email: Rails.application.credentials[:production][:doc_parser][:user_mail],
  password: rand.to_s[2..11],
  authentication_token: Rails.application.credentials[:production][:doc_parser][:user_token],
  admin: false
)

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
  rejection_motive: "non_applicable",
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
  invoice_type: "service_invoice",
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
 final_net_value: Money.new(4707414),
 final_fator: Money.new(226361),
 final_advalorem: Money.new(5802),
 final_protection: Money.new(926219),
)

i2 = Invoice.create!(
  invoice_type: "service_invoice",
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
 final_net_value: Money.new(2378166),
 final_fator: Money.new(114355),
 final_advalorem: Money.new(2948),
 final_protection: Money.new(486475),
)

puts "Operation 821 ........"

i1 = Invoice.create!(
  invoice_type: "service_invoice",
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
 final_net_value: Money.new(4582143),
 final_fator: Money.new(246524),
 final_advalorem: Money.new(6804),
 final_protection: Money.new(914478),
)

i2 = Invoice.create!(
  invoice_type: "service_invoice",
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
 received_at: nil,
 backoffice_status: "deposited",
 liquidation_status: "opened",
 value: Money.new(7315000),
 final_net_value: Money.new(6833448),
 final_fator: Money.new(431036),
 final_advalorem: Money.new(11938),
 final_protection: Money.new(1463000),
)

puts "Operation 823 ........"

i1 = Invoice.create!(
  invoice_type: "service_invoice",
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
 received_at: nil,
 backoffice_status: "deposited",
 liquidation_status: "opened",
 value: Money.new(1887000),
 final_net_value: Money.new(1760700),
 final_fator: Money.new(113416),
 final_advalorem: Money.new(3017),
 final_protection: Money.new(377400),
)

i2 = Invoice.create!(
  invoice_type: "service_invoice",
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
 final_net_value: Money.new(1284607),
 final_fator: Money.new(21847),
 final_advalorem: Money.new(570),
 final_protection: Money.new(262470),
)

puts "Operation 831 ........"

i1 = Invoice.create!(
  invoice_type: "service_invoice",
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
 final_net_value: Money.new(854317),
 final_fator: Money.new(23068),
 final_advalorem: Money.new(588),
 final_protection: Money.new(170864),
)

puts "Operation 844 ........"

i1 = Invoice.create!(
  invoice_type: "service_invoice",
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
 final_net_value: Money.new(5175271),
 final_fator: Money.new(247644),
 final_advalorem: Money.new(6373),
 final_protection: Money.new(1092120),
)

puts "Operation 848 ........"

i1 = Invoice.create!(
  invoice_type: "service_invoice",
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
 final_net_value: Money.new(1158228),
 final_fator: Money.new(55612),
 final_advalorem: Money.new(1431),
 final_protection: Money.new(245220),
)

puts "Operation 850 ........"

i1 = Invoice.create!(
  invoice_type: "service_invoice",
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
 final_net_value: Money.new(1925820),
 final_fator: Money.new(92063),
 final_advalorem: Money.new(2369),
 final_protection: Money.new(406000),
)

i2 = Invoice.create!(
  invoice_type: "service_invoice",
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
 final_net_value: Money.new(1955448),
 final_fator: Money.new(177549),
 final_advalorem: Money.new(4655),
 final_protection: Money.new(430000),
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
