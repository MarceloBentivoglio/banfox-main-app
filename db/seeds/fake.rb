puts "Starting seed............"
puts "Creating first seller, the ADMIN ......."
seller1 = Seller.create!(
  full_name: "Santini Santos",
  cpf: "72871151318",
  rf_full_name: "seed",
  rf_sit_cad: "seed",
  birth_date: "21/04/1989",
  mobile: "11998308090",
  company_name: "Biort Limitada",
  company_nickname: "Biort",
  cnpj: "08588244000149",
  phone: "1132355572",
  website: "www.biort.com.br",
  address: "rua dos Meninos",
  address_number: "213",
  address_comp: "predio",
  neighborhood: "Vila Olímpia",
  state: "SP",
  city: "São Paulo",
  zip_code: "04552000",
  inscr_est: "",
  inscr_mun: "",
  nire: "",
  company_type: 0,
  operation_limit: Money.new(20000000),
  monthly_revenue: Money.new(10000000),
  monthly_fixed_cost: Money.new(20000000),
  monthly_units_sold: 3000,
  cost_per_unit: Money.new(40000000),
  debt: Money.new(50000000),
  full_name_partner: "Santini Santos",
  cpf_partner: "72871151318",
  rf_full_name_partner: "seed",
  rf_sit_cad_partner: "seed",
  birth_date_partner: "21/04/1989",
  mobile_partner: "11998308090",
  email_partner: "santini@biort.com.br",
  consent: true,
  validation_status: "active",
  analysis_status: "approved",
  rejection_motive: "rejection_motive_non_applicable",
  visited: true,
  fator: 0.05,
  advalorem: 0.003,
  protection: 0.2,
)

payer1 = Payer.create!(
    company_name: "FICTÍCIO",
    cnpj:"23198636000195",
    fator: 0.05,
    advalorem: 0.001,
)

user1 = User.create!(
  email: "admin@biort.com.br",
  password: 123123,
  seller: seller1,
  admin: true,
)

# Creating invoices
# liquidado
i1 = Invoice.create!(
  invoice_type: "merchandise_invoice",
  number: "000004848",
  seller: seller1,
  payer: payer1,
)

i6 = Invoice.create!(
  invoice_type: "merchandise_invoice",
  number: "000004901",
  seller: seller1,
  payer: payer1,
)
# em aberto
i2 = Invoice.create!(
  invoice_type: "merchandise_invoice",
  number: "000004849",
  seller: seller1,
  payer: payer1,
)
# atrasada com um installment pago
i3 = Invoice.create!(
  invoice_type: "merchandise_invoice",
  number: "000004850",
  seller: seller1,
  payer: payer1,
)
# atrasada com um installment aberto
i4 = Invoice.create!(
  invoice_type: "merchandise_invoice",
  number: "000004851",
  seller: seller1,
  payer: payer1,
)
# disponível para compra
i5 = Invoice.create!(
  invoice_type: "merchandise_invoice",
  number: "000004852",
  seller: seller1,
  payer: payer1,
  )

i7 = Invoice.create!(
  invoice_type: "merchandise_invoice",
  number: "000004902",
  seller: seller1,
  payer: payer1,
  )

# Creating operations
operation1 = Operation.create!(
  consent: true,
  signed: true,

)
operation2 = Operation.create!(
  consent: true,
  signed: true,
)
operation3 = Operation.create!(
  consent: true,
  signed: true,
)

# Creating installments
# for i1 liquidada
i = Installment.create!(
 invoice: i1,
 operation: operation1,
 number: "004.848/01",
 value: Money.new(3330000),
 ordered_at: Time.new(2018,2,10),
 due_date: Date.new(2018,5,10),
 backoffice_status: "deposited",
 liquidation_status: "paid",
)
 i.final_net_value = i.net_value
 i.final_fator = i.fator
 i.final_advalorem = i.advalorem
 i.final_protection = i.protection
 i.save!


i = Installment.create!(
 invoice: i1,
 operation: operation1,
 number: "004.848/02",
 value: Money.new(3430000),
 due_date: Time.new(2018,6,6),
 backoffice_status: "deposited",
 liquidation_status: "paid",
)
 i.final_net_value = i.net_value
 i.final_fator = i.fator
 i.final_advalorem = i.advalorem
 i.final_protection = i.protection
 i.save!

# for i2 em aberto
i = Installment.create!(
 invoice: i2,
 operation: operation1,
 number: "004.849/01",
 value: Money.new(3530000),
 due_date: Date.current - 10.days,
 backoffice_status: "deposited",
 liquidation_status: "paid",
)
 i.final_net_value = i.net_value
 i.final_fator = i.fator
 i.final_advalorem = i.advalorem
 i.final_protection = i.protection
 i.save!

i = Installment.create!(
 invoice: i2,
 operation: operation1,
 number: "004.849/02",
 value: Money.new(3630000),
 due_date: Date.current + 60.days,
 backoffice_status: "deposited",
 liquidation_status: "opened",
)
 i.final_net_value = i.net_value
 i.final_fator = i.fator
 i.final_advalorem = i.advalorem
 i.final_protection = i.protection
 i.save!

i = Installment.create!(
 invoice: i2,
 operation: operation1,
 number: "004.849/03",
 value: Money.new(3730000),
 due_date: Date.current + 90.days,
 backoffice_status: "deposited",
 liquidation_status: "opened",
)
 i.final_net_value = i.net_value
 i.final_fator = i.fator
 i.final_advalorem = i.advalorem
 i.final_protection = i.protection
 i.save!

# for i3 atrasada com um installment pago
i = Installment.create!(
 invoice: i3,
 operation: operation2,
 number: "004.850/01",
 value: Money.new(1000000),
 due_date: Date.current - 33.days,
 backoffice_status: "deposited",
 liquidation_status: "paid",
)
 i.final_net_value = i.net_value
 i.final_fator = i.fator
 i.final_advalorem = i.advalorem
 i.final_protection = i.protection
 i.save!

i = Installment.create!(
 invoice: i3,
 operation: operation2,
 number: "004.850/02",
 value: Money.new(1500000),
 due_date: Date.current - 3.days,
 backoffice_status: "deposited",
 liquidation_status: "opened",
)
 i.final_net_value = i.net_value
 i.final_fator = i.fator
 i.final_advalorem = i.advalorem
 i.final_protection = i.protection
 i.save!

# for i4 atrasada com um installment aberto
i = Installment.create!(
 invoice: i4,
 operation: operation2,
 number: "004.851/01",
 value: Money.new(3930000),
 due_date: Date.current - 5.days,
 backoffice_status: "deposited",
 liquidation_status: "opened",
)
 i.final_net_value = i.net_value
 i.final_fator = i.fator
 i.final_advalorem = i.advalorem
 i.final_protection = i.protection
 i.save!

i = Installment.create!(
 invoice: i4,
 operation: operation2,
 number: "004.851/02",
 value: Money.new(4030000),
 due_date: Date.current + 25.days,
 backoffice_status: "deposited",
 liquidation_status: "opened",
)
 i.final_net_value = i.net_value
 i.final_fator = i.fator
 i.final_advalorem = i.advalorem
 i.final_protection = i.protection
 i.save!

# For i5 disponivel para compra
  # parcela vencida
  Installment.create!(
    invoice: i5,
    number: "004.852/01",
    value: Money.new(2000000),
    due_date: Date.current - 30.days,
    backoffice_status: "unavailable",
    unavailability: "due_date_past",
  )
  # parcela a vencer
  Installment.create!(
    invoice: i5,
    number: "004.852/02",
    value: Money.new(1800000),
    due_date: Date.current + 30.days,
    backoffice_status: "available",
  )
  # parcela a vencer
  Installment.create!(
    invoice: i5,
    number: "004.852/03",
    value: Money.new(1600000),
    due_date: Date.current + 60.days,
    backoffice_status: "available",
  )
  # parcela a vencer
  Installment.create!(
    invoice: i5,
    number: "004.852/04",
    value: Money.new(1400000),
    due_date: Date.current + 90.days,
    backoffice_status: "available",
  )
  # parcela a vencer
  Installment.create!(
    invoice: i5,
    number: "004.852/05",
    value: Money.new(1200000),
    due_date: Date.current + 120.days,
    backoffice_status: "unavailable",
    unavailability: "due_date_later_than_limit",
  )

# For i7 disponivel para compra
  # parcela vencida
  Installment.create!(
    invoice: i7,
    number: "004.902/01",
    value: Money.new(1000000),
    due_date: Date.current - 30.days,
    backoffice_status: "unavailable",
    unavailability: "due_date_past",
  )
  # parcela a vencer
  Installment.create!(
    invoice: i7,
    number: "004.902/02",
    value: Money.new(800000),
    due_date: Date.current + 30.days,
    backoffice_status: "available",
  )
  # parcela a vencer
  Installment.create!(
    invoice: i7,
    number: "004.902/03",
    value: Money.new(600000),
    due_date: Date.current + 60.days,
    backoffice_status: "available",
  )
  # parcela a vencer
  Installment.create!(
    invoice: i7,
    number: "004.902/04",
    value: Money.new(400000),
    due_date: Date.current + 90.days,
    backoffice_status: "available",
  )
  # parcela a vencer
  Installment.create!(
    invoice: i7,
    number: "004.902/05",
    value: Money.new(200000),
    due_date: Date.current + 120.days,
    backoffice_status: "unavailable",
    unavailability: "due_date_later_than_limit",
  )

# for i6 apenas algummas parcelas operadas
Installment.create!(
  invoice: i6,
  number: "004.901/01",
  value: Money.new(530000),
  due_date: Date.current - 60.days,
  backoffice_status: "unavailable",
  unavailability: "due_date_past",
)

Installment.create!(
  invoice: i6,
  number: "004.901/02",
  value: Money.new(630000),
  due_date: Date.current - 45.days,
  backoffice_status: "unavailable",
  unavailability: "already_operated",
)

i = Installment.create!(
  invoice: i6,
  operation: operation3,
  number: "004.901/03",
  value: Money.new(730000),
  due_date: Date.current - 20.days,
  backoffice_status: "deposited",
  liquidation_status: "pdd",
)
 i.final_net_value = i.net_value
 i.final_fator = i.fator
 i.final_advalorem = i.advalorem
 i.final_protection = i.protection
 i.save!

puts "Creating second seller, nota XML ......."
seller2 = Seller.create!(
  full_name: "Rodrigo Santini",
  cpf: "80287301087",
  rf_full_name: "seed",
  rf_sit_cad: "seed",
  birth_date: "11121952",
  mobile: "11998308090",
  company_name: "Biort Implantes Não Admin Ltda",
  company_nickname: "",
  cnpj: "16532989000114",
  phone: "11998308090",
  website: "asdfg",
  address: "Rua do Rocio",
  address_number: "450",
  address_comp: "",
  neighborhood: "Vila Olímpia",
  state: "SP",
  city: "São Paulo",
  zip_code: "04552000",
  inscr_est: "",
  inscr_mun: "",
  nire: "",
  company_type: "company_type_not_set",
  operation_limit_cents: 10000000,
  operation_limit_currency: "BRL",
  fator: 0.045,
  advalorem: 0.005,
  monthly_revenue_cents: 12341234,
  monthly_revenue_currency: "BRL",
  monthly_fixed_cost_cents: 2341,
  monthly_fixed_cost_currency: "BRL",
  monthly_units_sold: 2345,
  cost_per_unit_cents: 23451,
  cost_per_unit_currency: "BRL",
  debt_cents: 342,
  debt_currency: "BRL",
  full_name_partner: "Rodrigo Santini Main",
  cpf_partner: "80287301087",
  rf_full_name_partner: "Rodrigo Santini Main",
  rf_sit_cad_partner: "regular",
  birth_date_partner: "11121952",
  mobile_partner: "11998308090",
  email_partner: "joaquim@banfox.com.br",
  consent: true,
  validation_status: "active",
  visited: true,
  analysis_status: "approved",
  rejection_motive: "rejection_motive_non_applicable",
  protection: 0.15,
)

joint_debtor2 = JointDebtor.create!(
  name: "Joaquim Devedor",
  birthdate: Date.new(1989,04,21),
  mobile: "11998308090",
  documentation: "09670133645",
  email: "joaquim.oliveira.nt@gmail.com",
  seller: seller2,
)

user2 = User.create!(
  email: "xml@biort.com.br",
  password: 123123,
  seller: seller2,
  admin: false,
)

puts "Creating third seller, nota PDF ......."

seller3 = Seller.create!(
  full_name: "AntONIO Bena DA silva",
  cpf: "20477293000",
  rf_full_name: "antonio bena da silva",
  rf_sit_cad: "regular",
  birth_date: "21041989",
  mobile: "11998308090",
  company_name: "FLUIDTEC SISTEMAS DE AUTOMACAO EIRELI EPP",
  company_nickname: "fluidtec fake",
  cnpj: "99293918000133",
  phone: "3432355572",
  website: "dfghjk",
  address: "Avenida Angélica",
  address_number: "2345",
  address_comp: "de 1711 ao fim - lado ímpar",
  neighborhood: "Consolação",
  state: "SP",
  city: "São Paulo",
  zip_code: "01227200",
  inscr_est: "",
  inscr_mun: "",
  nire: "",
  company_type: "company_type_not_set",
  operation_limit_cents: 30000000,
  operation_limit_currency: "BRL",
  fator: 0.039,
  advalorem: 0.001,
  monthly_revenue_cents: 23456734567,
  monthly_revenue_currency: "BRL",
  monthly_fixed_cost_cents: 23456,
  monthly_fixed_cost_currency: "BRL",
  monthly_units_sold: 234567,
  cost_per_unit_cents: 23456,
  cost_per_unit_currency: "BRL",
  debt_cents: 23456,
  debt_currency: "BRL",
  full_name_partner: "antonio bena da silva",
  cpf_partner: "20477293000",
  rf_full_name_partner: "antonio bena da silva",
  rf_sit_cad_partner: "regular",
  birth_date_partner: "21041989",
  mobile_partner: "11998308090",
  email_partner: "joaquim@banfox.com.br",
  consent: true,
  validation_status: "active",
  visited: true,
  analysis_status: "approved",
  rejection_motive: "rejection_motive_non_applicable",
  protection: 0.2,
)

joint_debtor3 = JointDebtor.create!(
  name: "Joaquim Devedor da Fluidtec",
  birthdate: Date.new(1989,04,21),
  mobile: "11998308090",
  documentation: "09670133645",
  email: "joaquim.oliveira.nt@gmail.com",
  seller: seller3,
)

user3 = User.create!(
  email: "pdf@fluidtec.com.br",
  password: 123123,
  seller: seller3,
  admin: false,
)

puts "Creating Doc Parser user, nota PDF ......."

user4 = User.create!(
  email: Rails.application.credentials[:development][:doc_parser][:user_mail],
  password: rand.to_s[2..11],
  authentication_token: Rails.application.credentials[:development][:doc_parser][:user_token],
  admin: false
)

puts "............ seed ended"
puts "Users:"
puts "ADMIN: email: #{user1.email} \npassword: #{user1.password}"
puts "XML: email: #{user2.email} \npassword: #{user2.password}"
puts "PDF: email: #{user3.email} \npassword: #{user3.password}"
puts "DOCParser: email: #{user4.email} \npassword: #{user4.password}"


