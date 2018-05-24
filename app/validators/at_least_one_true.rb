class AtLeastOneTrue < ActiveModel::Validator
  def validate(record)
    unless options[:fields].any?{|field| record.send(field)}
      # record.errors[:base] << "Marque ao menos uma das opções"
      record.errors.add(:option_buttons, "Marque ao menos uma das opções")
    end
  end
end

