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
  validation_status: 5,
  analysis_status: 3,
  visited: false,
  fator: 0.05,
  advalorem: 0.003,
)

payer1 = Payer.create!(
    company_name: "Ficticio",
    cnpj:"23198636000195",
    fator: 0.05,
    advalorem: 0.001,
)

user1 = User.create!(
  email: "santini@biort.com.br",
  password: 123123,
  seller: seller1,
  admin: true,
)

# Creating invoices
# liquidado
i1 = Invoice.create!(
  invoice_type: "traditional_invoice",
  number: "000004848",
  seller: seller1,
  payer: payer1,
)

i6 = Invoice.create!(
  invoice_type: "traditional_invoice",
  number: "000004901",
  seller: seller1,
  payer: payer1,
)
# em aberto
i2 = Invoice.create!(
  invoice_type: "traditional_invoice",
  number: "000004849",
  seller: seller1,
  payer: payer1,
)
# atrasada com um installment pago
i3 = Invoice.create!(
  invoice_type: "traditional_invoice",
  number: "000004850",
  seller: seller1,
  payer: payer1,
)
# atrasada com um installment aberto
i4 = Invoice.create!(
  invoice_type: "traditional_invoice",
  number: "000004851",
  seller: seller1,
  payer: payer1,
)
# disponível para compra
i5 = Invoice.create!(
  invoice_type: "traditional_invoice",
  number: "000004852",
  seller: seller1,
  payer: payer1,
  )

i7 = Invoice.create!(
  invoice_type: "traditional_invoice",
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
Installment.create!(
 invoice: i1,
 operation: operation1,
 number: "004.848/01",
 value: Money.new(3330000),
 order_date: Date.new(2018,2,10),
 due_date: Date.new(2018,5,10),
 backoffice_status: "deposited",
 liquidation_status: "paid",
)

Installment.create!(
 invoice: i1,
 operation: operation1,
 number: "004.848/02",
 value: Money.new(3430000),
 due_date: Date.new(2018,6,6),
 backoffice_status: "deposited",
 liquidation_status: "paid",
)

# for i2 em aberto
Installment.create!(
 invoice: i2,
 operation: operation1,
 number: "004.849/01",
 value: Money.new(3530000),
 due_date: Date.current - 10.days,
 backoffice_status: "deposited",
 liquidation_status: "paid",
)

Installment.create!(
 invoice: i2,
 operation: operation1,
 number: "004.849/02",
 value: Money.new(3630000),
 due_date: Date.current + 60.days,
 backoffice_status: "deposited",
 liquidation_status: "opened",
)

Installment.create!(
 invoice: i2,
 operation: operation1,
 number: "004.849/03",
 value: Money.new(3730000),
 due_date: Date.current + 90.days,
 backoffice_status: "deposited",
 liquidation_status: "opened",
)

# for i3 atrasada com um installment pago
Installment.create!(
 invoice: i3,
 operation: operation2,
 number: "004.850/01",
 value: Money.new(1000000),
 due_date: Date.current - 33.days,
 backoffice_status: "deposited",
 liquidation_status: "paid",
)

Installment.create!(
 invoice: i3,
 operation: operation2,
 number: "004.850/02",
 value: Money.new(1500000),
 due_date: Date.current - 3.days,
 backoffice_status: "deposited",
 liquidation_status: "opened",
)

# for i4 atrasada com um installment aberto
Installment.create!(
 invoice: i4,
 operation: operation2,
 number: "004.851/01",
 value: Money.new(3930000),
 due_date: Date.current - 5.days,
 backoffice_status: "deposited",
 liquidation_status: "opened",
)

Installment.create!(
 invoice: i4,
 operation: operation2,
 number: "004.851/02",
 value: Money.new(4030000),
 due_date: Date.current + 25.days,
 backoffice_status: "deposited",
 liquidation_status: "opened",
)

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

Installment.create!(
 invoice: i6,
 operation: operation3,
 number: "004.901/03",
 value: Money.new(730000),
 due_date: Date.current - 30.days,
 backoffice_status: "deposited",
 liquidation_status: "rebought",
)

Installment.create!(
 invoice: i6,
 operation: operation3,
 number: "004.901/03",
 value: Money.new(730000),
 due_date: Date.current - 20.days,
 backoffice_status: "deposited",
 liquidation_status: "pdd",
)


puts "............ seed ended"
puts "Users:"
puts "email: #{user1.email} \npassword: #{user1.password}"
