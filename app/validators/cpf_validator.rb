class CpfValidator < ActiveModel::Validator
  def validate(record)
    unless CPF.valid?(record.cpf, strict: true)
      record.errors.add(:cpf_validator, "CPF não válido")
    end
  end
end

