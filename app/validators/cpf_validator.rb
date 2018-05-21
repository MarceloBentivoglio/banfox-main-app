class CpfValidator < ActiveModel::Validator
  def validate(record)
    unless CPF.valid?(record.cpf, strict: true)
      record.errors[:base] << "CPF não válido"
    end
  end
end

