puts "Starting seed............"
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
  operation_limit: Money.new(1000000000),
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
  validation_status: 5,
  analysis_status: 3,
  visited: false,
)

payer1 = Payer.create!(
    company_name: "Ficticio",
    cnpj:"23198636000195",
)

user1 = User.create!(
  email: "santini@biort.com.br",
  password: 123123,
  seller: seller1,
  admin: true,
)

# Creating invoices
operation1 = Operation.create!(
)

# liquidado
i1 = Invoice.create!(
  invoice_type: "traditional_invoice",
  number: "000004848",
  seller: seller1,
  payer: payer1,
  operation: operation1,
  backoffice_status: "deposited",
)
# em aberto
i2 = Invoice.create!(
  invoice_type: "traditional_invoice",
  number: "000004849",
  seller: seller1,
  payer: payer1,
  operation: operation1,
  backoffice_status: "deposited",
)
# atrasada com um installment pago
i3 = Invoice.create!(
  invoice_type: "traditional_invoice",
  number: "000004850",
  seller: seller1,
  payer: payer1,
  operation: operation1,
  backoffice_status: "deposited",
)
# atrasada com um installment aberto
i4 = Invoice.create!(
  invoice_type: "traditional_invoice",
  number: "000004851",
  seller: seller1,
  payer: payer1,
  operation: operation1,
  backoffice_status: "deposited",
)

# Creating installments

# for i1 liquidada
Installment.create!(
 invoice: i1,
 number: "004.848/01",
 value: Money.new(3330000),
 due_date: Date.new(2018,5,10),
 liquidation_status: "paid",
)

Installment.create!(
 invoice: i1,
 number: "004.848/02",
 value: Money.new(3430000),
 due_date: Date.new(2018,6,6),
 liquidation_status: "paid",
)

# for i2 em aberto
Installment.create!(
 invoice: i2,
 number: "004.849/01",
 value: Money.new(3530000),
 due_date: Date.new(2018,5,10),
 liquidation_status: "paid",
)

Installment.create!(
 invoice: i2,
 number: "004.849/02",
 value: Money.new(3630000),
 due_date: Date.new(2018,12,6),
 liquidation_status: "opened",
)

# for i3 atrasada com um installment pago
Installment.create!(
 invoice: i3,
 number: "004.850/01",
 value: Money.new(3730000),
 due_date: Date.new(2018,5,10),
 liquidation_status: "paid",
)

Installment.create!(
 invoice: i3,
 number: "004.850/02",
 value: Money.new(3830000),
 due_date: Date.new(2018,6,6),
 liquidation_status: "opened",
)

# for i4 atrasada com um installment aberto
Installment.create!(
 invoice: i4,
 number: "004.851/01",
 value: Money.new(3930000),
 due_date: Date.new(2018,6,6),
 liquidation_status: "opened",
)

Installment.create!(
 invoice: i4,
 number: "004.851/02",
 value: Money.new(4030000),
 due_date: Date.new(2018,12,6),
 liquidation_status: "opened",
)

puts "............ seed ended"
puts "Users:"
puts "email: #{user1.email} \npassword: #{user1.password}"
