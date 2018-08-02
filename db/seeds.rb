puts "Starting seed............"
seller1 = Seller.create!(
  full_name: "Zaida",
  cpf: "55598038714",
  phone: "0119999999",
  company_name: "Custom Water",
  cnpj: "11304146000147",
  monthly_revenue: Money.new(10000000),
  monthly_fixed_cost: Money.new(20000000),
  monthly_units_sold: 3000,
  cost_per_unit: Money.new(40000000),
  debt: Money.new(50000000),
  consent: true,
  validation_status: 3,
)

seller2 = Seller.create!(
  full_name: "Santini",
  cpf: "728.711.513-18",
  phone: "01199999",
  company_name: "Biort",
  cnpj: "08588244000149",
  monthly_revenue: Money.new(10000000),
  monthly_fixed_cost: Money.new(20000000),
  monthly_units_sold: 3000,
  cost_per_unit: Money.new(40000000),
  debt: Money.new(50000000),
  consent: true,
  validation_status: 3,
)

user1 = User.create!(
  email: "seller1@gmail.com",
  password: 123123,
  seller: seller1,
)

user2 = User.create!(
  email: "seller2@gmail.com",
  password: 123123,
  seller: seller2,
)
puts "............ seed ended"
puts "Users:"
puts "email: #{user1.email} \npassword: #{user1.password}"
puts "email: #{user2.email} \npassword: #{user2.password}"

# # Creating invoices
# # liquidado
# i1 = Invoice.create!(
#   invoice_type: "traditional_invoice",
#   number: "000004848",
#   seller_id: 1,
#   payer_id: 1,
#   backoffice_status: "deposited",
# )
# # em aberto
# i2 = Invoice.create!(
#   invoice_type: "traditional_invoice",
#   number: "000004849",
#   seller_id: 1,
#   payer_id: 1,
#   backoffice_status: "deposited",
# )
# # atrasada com um installment pago
# i3 = Invoice.create!(
#   invoice_type: "traditional_invoice",
#   number: "000004850",
#   seller_id: 1,
#   payer_id: 1,
#   backoffice_status: "deposited",
# )
# # atrasada com um installment aberto
# i4 = Invoice.create!(
#   invoice_type: "traditional_invoice",
#   number: "000004851",
#   seller_id: 1,
#   payer_id: 1,
#   backoffice_status: "deposited",
# )

# # Creating installments

# # for i1 liquidada
# Installment.create!(
#  invoice: i1,
#  number: "004.848/01",
#  value: Money.new(3330000),
#  due_date: Date.new(2018,5,10),
#  liquidation_status: "paid",
# )

# Installment.create!(
#  invoice: i1,
#  number: "004.848/02",
#  value: Money.new(3430000),
#  due_date: Date.new(2018,6,6),
#  liquidation_status: "paid",
# )

# # for i2 em aberto
# Installment.create!(
#  invoice: i2,
#  number: "004.849/01",
#  value: Money.new(3530000),
#  due_date: Date.new(2018,5,10),
#  liquidation_status: "paid",
# )

# Installment.create!(
#  invoice: i2,
#  number: "004.849/02",
#  value: Money.new(3630000),
#  due_date: Date.new(2018,12,6),
#  liquidation_status: "opened",
# )

# # for i3 atrasada com um installment pago
# Installment.create!(
#  invoice: i3,
#  number: "004.850/01",
#  value: Money.new(3730000),
#  due_date: Date.new(2018,5,10),
#  liquidation_status: "paid",
# )

# Installment.create!(
#  invoice: i3,
#  number: "004.850/02",
#  value: Money.new(3830000),
#  due_date: Date.new(2018,6,6),
#  liquidation_status: "opened",
# )

# # for i4 atrasada com um installment aberto
# Installment.create!(
#  invoice: i4,
#  number: "004.851/01",
#  value: Money.new(3930000),
#  due_date: Date.new(2018,6,6),
#  liquidation_status: "opened",
# )

# Installment.create!(
#  invoice: i4,
#  number: "004.851/02",
#  value: Money.new(4030000),
#  due_date: Date.new(2018,12,6),
#  liquidation_status: "opened",
# )
