purposes = ["Fabricação de Produtos", "Prestação de Serviços", "Revenda de Serviços"]
purposes.each do |purpose|
  Purpose.create!(name: purpose)
end
