class SellerAnalysis    
  def self.call(user, seller)
    if !CreditAnalysis::CpfCheckRF.new(seller).analyze
      seller.rejected!
      seller.allowed_to_operate = false
      seller.forbad_to_operate_at = Time.current
      seller.auto_veredict_at = Time.current
      seller.save!
      SellerMailer.rejected(user, seller).deliver_now

      #We will not reject a seller for insufficient revenue, that's why check_revenue was removed
      if seller.rejection_motive == "insuficient_revenue"
        SlackMessage.new("CC2NP6XHN", "<!channel> #{seller.company_name.titleize} \n cnpj: #{seller.cnpj} acabou de se cadastrar e foi *rejeitado* automaticamente por #{seller.rejection_motive} \n Receita: #{seller.monthly_revenue_cents&.fdiv(100)} \n Nome: #{seller.full_name}; Telefone: #{seller.mobile}; Email: #{seller.users.first.email} \n Partner: #{seller.full_name_partner}; Telefone: #{seller.mobile_partner}; Email: #{seller.email_partner}").send_now
      else
        SlackMessage.new("CC2NP6XHN", "<!channel> #{seller.company_name.titleize} \n cnpj: #{seller.cnpj} acabou de se cadastrar e foi *rejeitado* automaticamente por #{seller.rejection_motive}").send_now
        return false
      end
    end
    seller.pre_approved!
    seller.set_pre_approved_initial_standard_settings
    seller.auto_veredict_at = Time.current
    seller.allowed_to_operate = true
    seller.save!
    SellerMailer.welcome(user, seller).deliver_now
    SlackMessage.new("CC2NP6XHN", "<!channel> #{seller.company_name.titleize} \n cnpj: #{seller.cnpj} acabou de se cadastrar e foi *pré-aprovado*").send_now

    true
  rescue StandardError => e
    SlackMessage.new("CH1KSHZ2T", "Someone tried to finish seller_steps but had a problem in the analysis \n Erro: #{e.message}").send_now

    return false
  end
end
