module UserInputProcessing
  extend ActiveSupport::Concern

  def downcase_words
    %i{full_name company_name company_nickname website address address_number address_comp neighborhood state city nire full_name_partner email_partner email}.each do |attr|
      self.__send__(attr).downcase! unless self.try(attr).nil?
    end
  end

   def clean_inputs
    %i{mobile mobile_partner phone zip_code phone cpf cpf_partner cnpj birth_date birth_date_partner}.each do |attr|
      self.__send__(attr).gsub!(/[^0-9A-Za-z]/, '') unless self.try(attr).nil?
    end
  end

  def strip_cnpj
    self.cnpj = CNPJ::Formatter.strip(self.cnpj, strict: true)
  end

  def strip_cpf
    self.cpf = CPF::Formatter.strip(self.cpf, strict: true)
  end
end
