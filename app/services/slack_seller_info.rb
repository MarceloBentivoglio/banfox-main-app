class SlackSellerInfo
  def self.call(seller)
    SlackMessage.new("CC2NP6XHN", "<!channel> #{seller.company_name.titleize} \n cnpj: #{seller.cnpj} acabou de se cadastrar e foi *pré-aprovado*").send_now
  end
end
