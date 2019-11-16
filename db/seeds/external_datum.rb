file = File.new("#{Rails.root}/test/support/files/20190705_BIORT.txt", 'r')
biort_data = file.read

Risk::ExternalDatum.create(
  source: 'serasa_api',
  query: JSON.generate({cnpj: '16532989000114'}),
  ttl: DateTime.current + 1.year,
  raw_data: [biort_data]
)

file = File.new("#{Rails.root}/test/support/files/20190814_a_c_santa_catarina.txt", 'r')
santa_catarina_data = file.read

Risk::ExternalDatum.create(
  source: 'serasa_api',
  query: JSON.generate({cnpj: '08728220000148'}),
  ttl: DateTime.current + 1.year,
  raw_data: [santa_catarina_data]
)



