class CpfCheckRF
  # TODO: this is a horrible code! Refactor
  def initialize(seller)
    @applicant_cpf = seller.cpf
    @applicant_name = seller.full_name.downcase.split
    @partner_cpf = seller.cpf_partner
    @partner_name = seller.full_name_partner.downcase.split
    @seller = seller
    @cpfs = []
    @names = []
    @sit_cad = []
  end

  def analyse
    define_cpfs_to_check
    @cpfs.each do |cpf|
      @names << fetch_name_from_rf(cpf).downcase
    end
    @seller.rf_full_name = @names.first
    @seller.rf_sit_cad = @sit_cad.first
    @seller.rf_partner_full_name = @names.last unless @applicant_cpf == @partner_cpf
    @seller.rf_partner_sit_cad = @sit_cad.last unless @applicant_cpf == @partner_cpf
    @seller.save!
    check = compare_str(@applicant_name, @names.first)
    check = compare_str(@partner_name, @names.last) unless @applicant_cpf == @partner_cpf
    return check
  end

  def define_cpfs_to_check
    @cpfs << @applicant_cpf
    @cpfs << @partner_cpf unless @applicant_cpf == @partner_cpf
  end

  def fetch_name_from_rf(cpf)
    url = "https://consulta-situacao-cpf-cnpj.p.mashape.com/consultaSituacaoCPF?cpf={#{cpf}}"
    response = Unirest.get(url,
      headers= {
        'X-Mashape-Key' => Rails.application.credentials[Rails.env.to_sym][:mashape_key],
        'Accept' => 'application/json'
    })
    response.body["nome"]
  end

  def compare_str(user_inputs, rf)
    user_inputs.any? do |user_input|
      rf.include?(user_input)
    end
  end


end
