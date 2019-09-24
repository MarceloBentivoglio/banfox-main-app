class CpfValidator < ActiveModel::Validator
  def validate(record)
    cpf = record.__send__(options[:attr])
    unless CPF.valid?(cpf, strict: true)
      record.errors.add(:cpf, "CPF não válido")
    end
  end
end

