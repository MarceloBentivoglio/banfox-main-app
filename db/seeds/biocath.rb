puts "Creating Biocath..........."

biocath = Seller.create!(
  full_name: "livia",
  cpf: "34514993808",
  rf_full_name: "livia bergamo anselmo",
  rf_sit_cad: "regular",
  birth_date: "04041986",
  mobile: "11982924204",
  company_name: "biocath comercio de produtos hospitalares ltda",
  company_nickname: "biocath",
  cnpj: "05964709000120",
  phone: "1150703670",
  website: "www.biocath.com.br",
  address: "rua santa cruz",
  address_number: "1040",
  address_comp: "até 1450 - lado par",
  neighborhood: "vila mariana",
  state: "sp",
  city: "são paulo",
  zip_code: "04122000",
  inscr_est: "",
  inscr_mun: "",
  nire: "",
  company_type: "ltda",
  operation_limit_cents: 50000000,
  operation_limit_currency: "BRL",
  fator: 0.0363,
  advalorem: 0.001,
  monthly_revenue_cents: 500005000,
  monthly_revenue_currency: "BRL",
  monthly_fixed_cost_cents: 100000000,
  monthly_fixed_cost_currency: "BRL",
  monthly_units_sold: 6500,
  cost_per_unit_cents: 220000000,
  cost_per_unit_currency: "BRL",
  debt_cents: 450000000,
  debt_currency: "BRL",
  full_name_partner: "livia bergamo anselmo",
  cpf_partner: "34514993808",
  rf_full_name_partner: "livia bergamo anselmo",
  rf_sit_cad_partner: "regular",
  birth_date_partner: "04041986",
  mobile_partner: "11982924204",
  email_partner: "livia.anselmo@biocath.com.br",
  consent: true,
  validation_status: "active",
  visited: true,
  analysis_status: "approved",
  rejection_motive: "rejection_motive_non_applicable",
  protection: 0.2,
)

biocath_user = User.create!(
  email: "livia.anselmo@biocath.com.br",
  password: "biocath",
  admin: false,
  seller: biocath,
)
