# Creating invoices
# liquidado
i1 = Invoice.create!(
  invoice_type: "traditional_invoice",
  number: "000004848",
  seller_id: 1,
  payer_id: 1,
  backoffice_status: "deposited",
)
# em aberto
i2 = Invoice.create!(
  invoice_type: "traditional_invoice",
  number: "000004849",
  seller_id: 1,
  payer_id: 1,
  backoffice_status: "deposited",
)
# atrasada com um installment pago
i3 = Invoice.create!(
  invoice_type: "traditional_invoice",
  number: "000004850",
  seller_id: 1,
  payer_id: 1,
  backoffice_status: "deposited",
)
# atrasada com um installment aberto
i4 = Invoice.create!(
  invoice_type: "traditional_invoice",
  number: "000004851",
  seller_id: 1,
  payer_id: 1,
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
