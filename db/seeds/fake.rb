puts "Starting seed............"
puts "Creating first seller, the ADMIN ......."
seller1 = Seller.create!(
  full_name: "Santini Santos",
  cpf: "72871151318",
  rf_full_name: "seed",
  rf_sit_cad: "seed",
  birth_date: "21/04/1989",
  mobile: "11998308090",
  company_name: "Biort Materiais de Implantes Importação Limitada",
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
    company_name: "hospital cristovão da gama s.a	",
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
  invoice_type: "merchandise",
  number: "4848",
  seller: seller1,
  payer: payer1,
)

i6 = Invoice.create!(
  invoice_type: "merchandise",
  number: "4901",
  seller: seller1,
  payer: payer1,
)
# em aberto
i2 = Invoice.create!(
  invoice_type: "merchandise",
  number: "4849",
  seller: seller1,
  payer: payer1,
)
# atrasada com um installment pago
i3 = Invoice.create!(
  invoice_type: "merchandise",
  number: "4850",
  seller: seller1,
  payer: payer1,
)
# atrasada com um installment aberto
i4 = Invoice.create!(
  invoice_type: "merchandise",
  number: "4851",
  seller: seller1,
  payer: payer1,
)
# disponível para compra
i5 = Invoice.create!(
  invoice_type: "merchandise",
  number: "4852",
  seller: seller1,
  payer: payer1,
  )

i7 = Invoice.create!(
  invoice_type: "merchandise",
  number: "4902",
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
# for i1 paid on day
i = Installment.create!(
 invoice: i1,
 operation: operation1,
 number: "1",
 value: Money.new(3330000),
 ordered_at: Time.current - 150.days,
 due_date: Date.current - 90.days,
)
 i.initial_fator = i.fator
 i.initial_advalorem = i.advalorem
 i.initial_protection = i.protection
 i.final_fator = i.fator
 i.final_advalorem = i.advalorem
 i.final_protection = i.protection
 i.veredict_at = Time.current - 150.days
 i.deposited_at = Time.current - 150.days
 i.finished_at = Time.current - 90.days
 i.deposited!
 i.paid!


# for i1 paid with delay
i = Installment.create!(
 invoice: i1,
 operation: operation1,
 number: "2",
 value: Money.new(3430000),
 due_date: Date.current - 30.days,
 ordered_at: Time.current - 90.days,
)
 i.initial_fator = i.fator
 i.initial_advalorem = i.advalorem
 i.initial_protection = i.protection
 delta_fator = i.value * (1 - 1/(1 + i.invoice.fator)**((70 + 3) / 30.0)) - i.initial_fator
 delta_advalorem = i.value * (1 - 1/(1 + i.invoice.advalorem)**((70 + 3) / 30.0)) - i.initial_advalorem
 i.final_fator = i.initial_fator + delta_fator
 i.final_advalorem = i.initial_advalorem + delta_advalorem
 i.final_protection = i.initial_protection - (delta_fator + delta_advalorem)
 i.veredict_at = Time.current - 90.days
 i.deposited_at = Time.current - 90.days
 i.finished_at = Time.current - 20.days
 i.deposited!
 i.paid!


# for i2 em aberto
# for installment paid with delay
i = Installment.create!(
 invoice: i2,
 operation: operation1,
 number: "1",
 value: Money.new(3530000),
 due_date: Date.current - 30.days,
 ordered_at: Time.current - 90.days,
)
 i.initial_fator = i.fator
 i.initial_advalorem = i.advalorem
 i.initial_protection = i.protection
 delta_fator = i.value * (1 - 1/(1 + i.invoice.fator)**((70 + 3) / 30.0)) - i.initial_fator
 delta_advalorem = i.value * (1 - 1/(1 + i.invoice.advalorem)**((70 + 3) / 30.0)) - i.initial_advalorem
 i.final_fator = i.initial_fator + delta_fator
 i.final_advalorem = i.initial_advalorem + delta_advalorem
 i.final_protection = i.initial_protection - (delta_fator + delta_advalorem)
 i.veredict_at = Time.current - 90.days
 i.deposited_at = Time.current - 90.days
 i.finished_at = Time.current - 20.days
 i.deposited!
 i.paid!


i = Installment.create!(
 invoice: i2,
 operation: operation1,
 number: "2",
 value: Money.new(3630000),
 ordered_at: Time.current - 30.days,
 due_date: Date.current + 30.days,
)
 i.initial_fator = i.fator
 i.initial_advalorem = i.advalorem
 i.initial_protection = i.protection
 i.veredict_at = Time.current - 30.days
 i.deposited_at = Time.current - 30.days
 i.deposited!
 i.opened!


i = Installment.create!(
 invoice: i2,
 operation: operation1,
 number: "3",
 value: Money.new(3730000),
 ordered_at: Time.current - 30.days,
 due_date: Date.current + 60.days,
)
 i.initial_fator = i.fator
 i.initial_advalorem = i.advalorem
 i.initial_protection = i.protection
 i.veredict_at = Time.current - 30.days
 i.deposited_at = Time.current - 30.days
 i.deposited!
 i.opened!


# for i3 atrasada com um installment pago
# installment pago em atraso
 i = Installment.create!(
 invoice: i3,
 operation: operation2,
 number: "1",
 value: Money.new(1000000),
 due_date: Date.current - 60.days,
 ordered_at: Time.current - 90.days,
)
 i.initial_fator = i.fator
 i.initial_advalorem = i.advalorem
 i.initial_protection = i.protection
 delta_fator = i.value * (1 - 1/(1 + i.invoice.fator)**((60 + 3) / 30.0)) - i.initial_fator
 delta_advalorem = i.value * (1 - 1/(1 + i.invoice.advalorem)**((60 + 3) / 30.0)) - i.initial_advalorem
 i.final_fator = i.initial_fator + delta_fator
 i.final_advalorem = i.initial_advalorem + delta_advalorem
 i.final_protection = i.initial_protection - (delta_fator + delta_advalorem)
 i.veredict_at = Time.current - 90.days
 i.deposited_at = Time.current - 90.days
 i.finished_at = Time.current - 30.days
 i.deposited!
 i.paid!


i = Installment.create!(
 invoice: i3,
 operation: operation2,
 number: "2",
 value: Money.new(1500000),
 ordered_at: Time.current - 60.days,
 due_date: Date.current - 3.days,
)
 i.initial_fator = i.fator
 i.initial_advalorem = i.advalorem
 i.initial_protection = i.protection
 i.veredict_at = Time.current - 60.days
 i.deposited_at = Time.current - 60.days
 i.deposited!
 i.opened!


# for i4 atrasada com um installment aberto
i = Installment.create!(
 invoice: i4,
 operation: operation2,
 number: "1",
 value: Money.new(3930000),
 ordered_at: Time.current - 25.days,
 due_date: Date.current - 5.days,
)
 i.initial_fator = i.fator
 i.initial_advalorem = i.advalorem
 i.initial_protection = i.protection
 i.veredict_at = Time.current - 25.days
 i.deposited_at = Time.current - 25.days
 i.deposited!
 i.opened!


i = Installment.create!(
 invoice: i4,
 operation: operation2,
 number: "2",
 value: Money.new(4030000),
 ordered_at: Time.current - 25.days,
 due_date: Date.current + 25.days,
)
 i.initial_fator = i.fator
 i.initial_advalorem = i.advalorem
 i.initial_protection = i.protection
 i.veredict_at = Time.current - 25.days
 i.deposited_at = Time.current - 25.days
 i.deposited!
 i.opened!

# For i5 disponivel para compra
  # parcela vencida
  Installment.create!(
    invoice: i5,
    number: "1",
    value: Money.new(2000000),
    due_date: Date.current - 30.days,
    backoffice_status: "unavailable",
    unavailability: "due_date_past",
  )
  # parcela a vencer
  Installment.create!(
    invoice: i5,
    number: "2",
    value: Money.new(1800000),
    due_date: Date.current + 30.days,
    backoffice_status: "available",
  )
  # parcela a vencer
  Installment.create!(
    invoice: i5,
    number: "3",
    value: Money.new(1600000),
    due_date: Date.current + 60.days,
    backoffice_status: "available",
  )
  # parcela a vencer
  Installment.create!(
    invoice: i5,
    number: "4",
    value: Money.new(1400000),
    due_date: Date.current + 90.days,
    backoffice_status: "available",
  )
  # parcela a vencer
  Installment.create!(
    invoice: i5,
    number: "5",
    value: Money.new(1200000),
    due_date: Date.current + 120.days,
    backoffice_status: "unavailable",
    unavailability: "due_date_later_than_limit",
  )

# For i7 disponivel para compra
  # parcela vencida
  Installment.create!(
    invoice: i7,
    number: "1",
    value: Money.new(1000000),
    due_date: Date.current - 30.days,
    backoffice_status: "unavailable",
    unavailability: "due_date_past",
  )
  # parcela a vencer
  Installment.create!(
    invoice: i7,
    number: "2",
    value: Money.new(800000),
    due_date: Date.current + 30.days,
    backoffice_status: "available",
  )
  # parcela a vencer
  Installment.create!(
    invoice: i7,
    number: "3",
    value: Money.new(600000),
    due_date: Date.current + 60.days,
    backoffice_status: "available",
  )
  # parcela a vencer
  Installment.create!(
    invoice: i7,
    number: "4",
    value: Money.new(400000),
    due_date: Date.current + 90.days,
    backoffice_status: "available",
  )
  # parcela a vencer
  Installment.create!(
    invoice: i7,
    number: "5",
    value: Money.new(200000),
    due_date: Date.current + 120.days,
    backoffice_status: "unavailable",
    unavailability: "due_date_later_than_limit",
  )

# for i6 apenas algummas parcelas operadas
Installment.create!(
  invoice: i6,
  number: "1",
  value: Money.new(530000),
  due_date: Date.current - 60.days,
  backoffice_status: "unavailable",
  unavailability: "due_date_past",
)

Installment.create!(
  invoice: i6,
  number: "2",
  value: Money.new(630000),
  due_date: Date.current - 45.days,
  backoffice_status: "unavailable",
  unavailability: "already_operated",
)

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

puts "Creating fourth seller without protection......."
seller4 = Seller.create!(
  full_name: "Felipe Almeida dos Santos",
  cpf: "57161054087",
  rf_full_name: "seed",
  rf_sit_cad: "seed",
  birth_date: "11121952",
  mobile: "11998308090",
  company_name: "Biort Implantes Sem Proteção Ltda",
  company_nickname: "Biort Sem Proteção",
  cnpj: "80694330000163",
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
  full_name_partner: "Gustavo Campos",
  cpf_partner: "66254380064",
  rf_full_name_partner: "Gustavo campos",
  rf_sit_cad_partner: "regular",
  birth_date_partner: "11121952",
  mobile_partner: "11998308090",
  email_partner: "joaquim@banfox.com.br",
  consent: true,
  validation_status: "active",
  visited: true,
  analysis_status: "approved",
  rejection_motive: "rejection_motive_non_applicable",
  protection: 0,
  allowed_to_operate: true,
)

user4 = User.create!(
  email: "semprotecao@biort.com.br",
  password: 123123,
  seller: seller4,
  admin: false,
)

#invoice
i8 = Invoice.create!(
  invoice_type: "merchandise",
  number: "983496123",
  seller: seller4,
  payer: payer1,
)

operation4 = Operation.create!(
  consent: true,
  signed: true,
)

#Installments for i8 and operation4
# Creating installments
# for i8 paid on day
i = Installment.create!(
 invoice: i8,
 operation: operation4,
 number: "11",
 value: Money.new(3330000),
 ordered_at: Time.current - 150.days,
 due_date: Date.current - 90.days,
)
 i.initial_fator = i.fator
 i.initial_advalorem = i.advalorem
 i.initial_protection = i.protection
 i.final_fator = i.fator
 i.final_advalorem = i.advalorem
 i.final_protection = i.protection
 i.veredict_at = Time.current - 150.days
 i.deposited_at = Time.current - 150.days
 i.finished_at = Time.current - 90.days
 i.deposited!
 i.paid!

# for i8 atrasada com um installment pago
# installment pago em atraso
 i = Installment.create!(
 invoice: i8,
 operation: operation4,
 number: "12",
 value: Money.new(1000000),
 due_date: Date.current - 60.days,
 ordered_at: Time.current - 90.days,
)
 i.initial_fator = i.fator
 i.initial_advalorem = i.advalorem
 i.initial_protection = i.protection
 delta_fator = i.value * (1 - 1/(1 + i.invoice.fator)**((60 + 3) / 30.0)) - i.initial_fator
 delta_advalorem = i.value * (1 - 1/(1 + i.invoice.advalorem)**((60 + 3) / 30.0)) - i.initial_advalorem
 i.final_fator = i.initial_fator + delta_fator
 i.final_advalorem = i.initial_advalorem + delta_advalorem
 i.final_protection = i.initial_protection - (delta_fator + delta_advalorem)
 i.veredict_at = Time.current - 90.days
 i.deposited_at = Time.current - 90.days
 i.finished_at = Time.current - 30.days
 i.deposited!
 i.paid!

puts "Creating Doc Parser user, nota PDF ......."
user5 = User.create!(
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


