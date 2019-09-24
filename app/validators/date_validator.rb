class DateValidator < ActiveModel::Validator
  def validate(record)
    date = record.__send__(options[:attr])
    if date.instance_of?(String)
      date = Date.strptime(date, '%d%m%Y')
    end
    record.errors.add(options[:attr], "necessário ser maior de 16 anos") if date >= (Date.current - 16.years)
  rescue ArgumentError
    record.errors.add(options[:attr], "necessário ser maior de 16 anos")
  end
end

