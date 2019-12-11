cnpj_examples = [
  "06179342000105",
  "11129498000103",
  "11724617000176",
  "19687535000100",
  "23198636000195",
  "40936742000148"
]

cnpj_examples.each do |cnpj|
  File.open("#{Rails.root}/test/support/files/serasa_api/#{cnpj}.txt", 'r') do |file|
    puts "Serasa: Generating external datum for #{cnpj}"
    Risk::ExternalDatum.create(
      source: 'serasa_api',
      query: JSON.generate({cnpj: cnpj}),
      raw_data: [file.read],
      ttl: DateTime.current + 24.days
    )
  end
end

cnpj_examples.each do |cnpj|
  File.open("#{Rails.root}/test/support/files/big_data_corp/#{cnpj}.txt", 'r') do |file|
    puts "BigDataCorp: Generating external datum for #{cnpj}"
    Risk::ExternalDatum.create(
      source: 'big_data_corp',
      query: JSON.generate({key: "v0#{cnpj}"}),
      raw_data: eval(file.read),
      ttl: DateTime.current + 24.days
    )
  end
end
