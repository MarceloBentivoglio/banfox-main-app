class InvoicesDocumentsBundle < ApplicationRecord
  has_many_attached :documents, dependent: :purge
end
