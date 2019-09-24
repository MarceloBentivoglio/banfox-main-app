class CnpjValidator < ActiveModel::Validator
  def validate(record)
    unless CNPJ.valid?(record.cnpj, strict: true)
      record.errors.add(:cnpj, "CNPJ não válido")
    end
  end
end
