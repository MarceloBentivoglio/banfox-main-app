class CpfCheckRF
  # TODO: this is a horrible code! Refactor
  def initialize(seller)
    @applicant_cpf = seller.cpf
    @applicant_name = seller.full_name.downcase.split
    @partner_cpf = seller.cpf_partner
    @partner_name = seller.full_name_partner.downcase.split
    @same_person = @applicant_cpf == @partner_cpf
    @seller = seller
    @cpfs = []
    @rf_infos = []
    @rf_names = []
    @rf_sit_cad =[]
    @rf_cpfs_valid = true
    @inputs_checks_w_rf = false
  end

  def analyze
    define_cpfs_to_check
    set_rf_infos
    treat_rf_infos
    persist_rf_infos
    compare_input_w_rf
    persist_analysis_conclusion
    return @inputs_checks_w_rf
  end

  def define_cpfs_to_check
    @cpfs << @applicant_cpf
    @cpfs << @partner_cpf unless @same_person
  end

  def set_rf_infos
    @cpfs.each do |cpf|
      @rf_infos << fetch_rf_info(cpf)
    end
  end

  def fetch_rf_info(cpf)
    url = "https://consulta-situacao-cpf-cnpj.p.rapidapi.com/consultaSituacaoCPF?cpf={#{cpf}}"
    Timeout::timeout(5) do
      headers = { "X-RapidAPI-Key" => Rails.application.credentials[Rails.env.to_sym][:rapidapi_key] }
      serialized_rf_info = RestClient.get(url, headers)
      rf_info = JSON.parse(serialized_rf_info)
    end
  end

  def treat_rf_infos
    @rf_infos.each do |rf_info|
      @rf_names << rf_info['nome'].downcase
      @rf_sit_cad << rf_info['situacaoCadastral'].downcase
    end
  end

  def persist_rf_infos
    ActiveRecord::Base.transaction do
      @seller.rf_full_name = @rf_names.first
      @seller.rf_sit_cad = @rf_sit_cad.first
      @seller.rf_full_name_partner = @same_person ? @rf_names.first : @rf_names.last
      @seller.rf_sit_cad_partner = @same_person ? @rf_sit_cad.first : @rf_sit_cad.last
      @seller.save!
    end
  end

  def compare_input_w_rf
    if @rf_cpfs_valid
      @inputs_checks_w_rf = compare_str(@applicant_name, @rf_names.first)
      @inputs_checks_w_rf = compare_str(@partner_name, @rf_names.last) unless @same_person
    end
  end

  def compare_str(names, rf)
    names.any? do |name|
      rf.include?(name)
    end
  end

  def persist_analysis_conclusion
    if !@rf_cpfs_valid || !@inputs_checks_w_rf
      @seller.rejected!
      @seller.no_match_w_rf!
    end
  end
end
