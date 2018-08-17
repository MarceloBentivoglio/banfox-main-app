class DateValidator < ActiveModel::Validator
  def validate(record)
    date = record.__send__(options[:attr])
    record.errors.add(:date_validator, "data não válida") if Date.strptime(date, '%d%m%Y') > Date.current
    rescue ArgumentError
      record.errors.add(:date_validator, "data não válida")
  end
end

