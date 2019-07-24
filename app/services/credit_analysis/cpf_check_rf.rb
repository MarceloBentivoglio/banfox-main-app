#TODO cahnge to receita federal
class CpfCheckRF
  #ATTENTION This variable maybe should be in a db so that we can change it easily
  @@minimum_similarity_accepted = 0.7

  # TODO: this is a horrible code! Refactor
  def initialize(seller)
    @applicant_cpf = seller.cpf
    @applicant_name = seller.full_name
    @partner_cpf = seller.cpf_partner
    @partner_name = seller.full_name_partner
    #todo this is a behavior change it for the model
    @same_person = @applicant_cpf == @partner_cpf
    @seller = seller
    @cpfs = []
    @rf_infos = []
    @rf_names = []
    @rf_sit_cad =[]
    @inputs_checks_w_rf = false
  end

  # This sis a facade
  def analyze
    define_cpfs_to_check
    set_rf_infos
    split_rf_infos
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
    Timeout::timeout(10) do
      #TODO explicit this code
      #TOOO BigBoostCpfInfo.fetch_information(cpf)
      rf_cpf_info = BigBoostCpfInfo.new(cpf)
      return rf_cpf_info.treated_cpf_info
    end
  end

  def split_rf_infos
    @rf_infos.each do |rf_info|
      @rf_names << rf_info[:name]
      @rf_sit_cad << rf_info[:taxIdStatus]
    end
  end

  def persist_rf_infos
    #TODO Take this transaction out
    ActiveRecord::Base.transaction do
      @seller.rf_full_name = @rf_names.first
      @seller.rf_sit_cad = @rf_sit_cad.first
      @seller.rf_full_name_partner = @same_person ? @rf_names.first : @rf_names.last
      @seller.rf_sit_cad_partner = @same_person ? @rf_sit_cad.first : @rf_sit_cad.last
      @seller.save!
    end
  end

  def compare_input_w_rf
    if @same_person
      @inputs_checks_w_rf = compare_str(@applicant_name, @rf_names.first)
    else
      @inputs_checks_w_rf = compare_str(@applicant_name, @rf_names.first) && compare_str(@partner_name, @rf_names.last)
    end
  end

  def compare_str(str1, str2)
    str1 = I18n.transliterate(str1)
    str2 = I18n.transliterate(str2)
    return JaroWinkler.distance(str1, str2) >= @@minimum_similarity_accepted ? true : false
  end

  #ATTENTION Maybe it could be a good ideia to make this update in one transaction only
  def persist_analysis_conclusion
    if !@inputs_checks_w_rf
      @seller.no_match_w_rf!
    end
  end
end
