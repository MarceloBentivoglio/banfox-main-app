class DocumentsValidator < ActiveModel::Validator
  def validate(record)
    unless record.documentation_completed?
      record.errors.add(:documents_validation, "é necessário subir todos os documentos")
    end
  end
end
